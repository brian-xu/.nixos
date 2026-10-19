#!/usr/bin/env bash
# substitute-probe.sh: why was terraform built locally instead of substituted?
#
# terraform is a stock nixpkgs package that cache.nixos.org definitely has.
# If it built locally, cache.nixos.org substitution failed — either the
# effective config lacks the key, or the exact path is somehow not cached.
# This script distinguishes the two.
#
# Usage (any user; sudo where needed):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/substitute-probe.sh -o /tmp/probe.sh
#   bash /tmp/probe.sh
set -uo pipefail

line() { printf '\n===== %s =====\n' "$1"; }
SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

line "Effective config — trusted-public-keys (the piece not compared before)"
echo "-- as $(id -un):"
nix show-config 2>/dev/null | grep -E '^(trusted-public-keys|substituters) ' | sed 's/^/  /'
echo "-- as root:"
$SUDO nix show-config 2>/dev/null | grep -E '^(trusted-public-keys|substituters) ' | sed 's/^/  /'

line "Raw /etc/nix/nix.conf"
cat /etc/nix/nix.conf 2>/dev/null | sed 's/^/  /' || echo "(missing)"

line "Daemon restart state"
systemctl show nix-daemon -p ActiveEnterTimestamp 2>/dev/null || echo "no systemd unit"
echo "nix.conf mtime: $(stat -c %y /etc/nix/nix.conf 2>/dev/null || echo n/a)"
echo "(if nix.conf is newer than the daemon start time, the daemon never saw it)"

line "Terraform dry-run (as root, what nixos-rebuild does)"
out=$(mktemp)
$SUDO nix build --dry-run nixpkgs#terraform 2>"$out"
echo "exit: $?"
grep -E 'will be built|will be fetched|nothing to be done' "$out" | sed 's/^/  /'
echo "-- warnings --"
grep -inE "ignor|not signed|trusted" "$out" | sed 's/^/  /' || echo "(none)"

line "Terraform narinfo probe (is the path even on the caches?)"
drv=$($SUDO nix eval --raw nixpkgs#terraform.outPath 2>/dev/null || true)
if [[ -n $drv ]]; then
  h=$(basename "$drv" | sed 's/-.*//')
  echo "  expected outPath: $drv"
  for cache in cache.nixos.org brian-xu.cachix.org; do
    code=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://$cache/$h.narinfo" || echo err)
    echo "  $cache/$h.narinfo -> $code"
  done
  echo "  (200 = the cache has it; 404 = genuinely not cached"
  echo "   — a 404 on cache.nixos.org for stock terraform means the nixpkgs"
  echo "   pin is newer than hydra's builds, which is rare but possible"
  echo "   on a just-cut channel bump)"
else
  echo "  (could not resolve terraform outPath)"
fi

line "Verdict guide"
cat <<'EOF'
- trusted-public-keys differs between user and root, or lacks any of the
  three keys -> fix /etc/nix/nix.conf (single line, all three keys), restart
  nix-daemon, rebuild.
- nix.conf mtime newer than daemon start -> daemon is running stale config;
  systemctl restart nix-daemon.
- dry-run says fetched, but the rebuild built it -> the rebuild runs with a
  different effective config than this probe; compare the two sections above.
- narinfo 404 on cache.nixos.org -> the path truly isn't cached (channel-bump
  gap); local build is correct behavior, push results with cache-push.sh.
EOF
