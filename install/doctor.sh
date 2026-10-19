#!/usr/bin/env bash
# doctor.sh: diagnose and fix Nix substituter trust problems.
#
# Prints the effective substituter/trust config, identifies why substitution
# is being ignored ("ignoring the following substituters", "not signed by
# any key"), and can rewrite the daemon's nix.conf with the correct settings.
#
# Usage (works as root or regular user with sudo):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/doctor.sh -o /tmp/doctor.sh
#   bash /tmp/doctor.sh            # diagnose only
#   bash /tmp/doctor.sh --fix      # diagnose + rewrite /etc/nix/nix.conf + restart daemon
set -euo pipefail

NIX_CONF=/etc/nix/nix.conf
SUBSTITUTERS="https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org"
TRUSTED_KEYS=(
  "cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g="
  "brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4="
  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
)

SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

echo "== Effective Nix config (daemon view) =="
$SUDO nix show-config 2>/dev/null | grep -E '^(substituters|trusted-public-keys|trusted-substituters|trusted-users) ' || {
  echo "  (nix show-config unavailable)"
}

echo
echo "== Config sources =="
echo "-- /etc/nix/nix.conf:"
$SUDO cat "$NIX_CONF" 2>/dev/null | sed 's/^/  /' || echo "  (missing)"
echo "-- ~/.config/nix/nix.conf:"
cat "${HOME}/.config/nix/nix.conf" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
echo "-- NIX_* environment:"
env | grep -i '^NIX_' | sed 's/^/  /' || echo "  (none)"

echo
echo "== Diagnosis =="
conf_substituters=$($SUDO cat "$NIX_CONF" 2>/dev/null | grep -E '^substituters' || true)
conf_keys=$($SUDO cat "$NIX_CONF" 2>/dev/null | grep -E '^trusted-public-keys' || true)

problems=0
for key in "${TRUSTED_KEYS[@]}"; do
  kid=${key%%:*}
  if ! $SUDO nix show-config 2>/dev/null | grep -q "$kid"; then
    echo "MISSING from effective trusted-public-keys: $kid"
    problems=$((problems+1))
  fi
done
for s in $SUBSTITUTERS; do
  if ! $SUDO nix show-config 2>/dev/null | grep -q "$s"; then
    echo "MISSING from effective substituters: $s"
    problems=$((problems+1))
  fi
done
[[ $problems -eq 0 ]] && echo "All substituters and keys present in the effective config."

if [[ ${1:-} == "--fix" ]]; then
  echo
  echo "== Fixing: rewriting $NIX_CONF and restarting nix-daemon =="
  $SUDO cp -f "$NIX_CONF" "$NIX_CONF.bak" 2>/dev/null || true
  $SUDO mkdir -p /etc/nix
  $SUDO tee "$NIX_CONF" > /dev/null <<EOF
substituters = $SUBSTITUTERS
trusted-public-keys = ${TRUSTED_KEYS[*]}
trusted-users = root $(id -un)
experimental-features = nix-command flakes
EOF
  $SUDO systemctl restart nix-daemon 2>/dev/null \
    || $SUDO pkill -HUP nix-daemon 2>/dev/null \
    || echo "  (could not restart nix-daemon — reboot to apply)"
  echo "Done. Verify with: sudo nix show-config | grep -E 'substituters|trusted'"
else
  echo
  echo "Run with --fix to rewrite $NIX_CONF and restart nix-daemon."
fi
