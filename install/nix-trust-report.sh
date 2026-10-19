#!/usr/bin/env bash
# nix-trust-report.sh: capture decisive evidence for "ignoring substituters".
#
# The warning "ignoring the following substituters from 'SOURCE'" names its
# source. That clause is the whole diagnosis — this script reproduces the
# warning with a cheap build and prints everything needed to act on it.
#
# Usage (as the user that runs the rebuild — brian):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/nix-trust-report.sh -o /tmp/report.sh
#   bash /tmp/report.sh | tee /tmp/trust-report.txt
set -uo pipefail

line() { printf '\n===== %s =====\n' "$1"; }

line "Nix implementation and version"
nix --version 2>&1
nix-env --version 2>&1 | head -1
command -v nix-daemon && nix-daemon --version 2>&1 | head -1 || echo "nix-daemon not in PATH"
grep -rE 'nix (pkgs|store) ?=|nixVersions|nix.package' /etc/os-release /run/current-system/nixos-version 2>/dev/null | head -2
readlink /run/current-system/sw/bin/nix 2>/dev/null || true

line "Identity"
echo "user: $(id -un) (uid $(id -u)) groups: $(id -nG)"

line "Environment (NIX_*)"
env | grep -i '^NIX_' || echo "(none)"

line "/etc/nix/nix.conf"
cat /etc/nix/nix.conf 2>/dev/null | sed 's/^/  /' || echo "(missing)"

line "~/.config/nix/nix.conf"
cat "${HOME}/.config/nix/nix.conf" 2>/dev/null | sed 's/^/  /' || echo "(none)"

line "/root/.config/nix/nix.conf"
sudo cat /root/.config/nix/nix.conf 2>/dev/null | sed 's/^/  /' || echo "(none)"

line "Effective config — as $(id -un)"
nix show-config 2>/dev/null | grep -E '^(substituters|trusted-public-keys|trusted-users|trusted-substituters) ' | sed 's/^/  /'

line "Effective config — as root"
sudo nix show-config 2>/dev/null | grep -E '^(substituters|trusted-public-keys|trusted-users|trusted-substituters) ' | sed 's/^/  /'

line "Daemon status"
systemctl is-active nix-daemon 2>/dev/null || echo "no systemd nix-daemon"

line "Reproduce the warning (tiny build, full stderr kept)"
# One trivial substitution attempt; any 'ignoring' warning prints its SOURCE.
out=$(mktemp)
nix build --no-link --print-out-paths nixpkgs#hello 2>"$out" >/dev/null
status=$?
echo "exit: $status"
echo "--- full stderr ---"
sed 's/^/  /' "$out"
echo "--- any 'ignoring' lines, verbatim ---"
grep -i "ignoring" "$out" || echo "(no ignoring warnings on this trivial build)"
rm -f "$out"

line "Interpretation guide"
cat <<'EOF'
The warning's "from 'X'" clause names the cause:

  from 'command line'  -> the invoking user is NOT trusted by the daemon.
                          Check trusted-users in the *effective* section above.
  from 'nix.conf'      -> a config file ABOVE is missing the keys, or the
                          daemon was not restarted since the last edit.
  from 'global'        -> /etc/nix/nix.conf (daemon) lacks substituters/keys.
  "not signed by any key"/"does not have a valid signature"
                      -> trusted-public-keys lacks the cache's key. The Sig:
                          line of the narinfo names the missing key.

Compare the two "Effective config" blocks: if root's view differs from the
user's view, trust is the issue; if both lack substituters, the daemon config
is the issue.
EOF
