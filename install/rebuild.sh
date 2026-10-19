#!/usr/bin/env bash
# rebuild.sh: apply the real flake with working substitution, from the
# throwaway system (stage 1 output) or any booted system.
#
# Trust is established via the daemon's nix.conf (doctor.sh --fix), not via
# --option flags: flags replace settings and have surprising interactions
# with multiple config sources, while the daemon config is authoritative.
#
# Usage (as brian or root):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/rebuild.sh -o /tmp/rebuild.sh
#   bash /tmp/rebuild.sh
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
NIX_CONF=/etc/nix/nix.conf
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

SUBSTITUTERS="https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org"
TRUSTED_KEYS="cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="

if [[ ! -d $REPO_DIR/.git ]]; then
  echo ">>> $REPO_DIR missing — clone it first (stage-2.sh does this) or set REPO_DIR" >&2
  exit 1
fi

SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

# Establish trust via the daemon config unless it is already correct.
need_fix=false
if ! $SUDO grep -q 'brian-xu.cachix.org' "$NIX_CONF" 2>/dev/null \
   || ! $SUDO grep -q 'cache.nixos.org-1' "$NIX_CONF" 2>/dev/null \
   || ! $SUDO grep -q 'niri.cachix.org-1' "$NIX_CONF" 2>/dev/null \
   || ! ($SUDO grep -Eq '^trusted-users.*\b'"$(id -un)"'\b' "$NIX_CONF" 2>/dev/null); then
  need_fix=true
fi

if [[ $need_fix == true ]]; then
  echo ">>> Fixing $NIX_CONF (trust for cachix + cache.nixos.org, trusted-users)"
  if ! $SUDO true 2>/dev/null; then
    echo ">>> sudo unavailable. Re-run as root instead:" >&2
    echo "    sudo bash $0" >&2
    exit 1
  fi
  $SUDO mkdir -p /etc/nix
  $SUDO cp -f "$NIX_CONF" "$NIX_CONF.bak" 2>/dev/null || true
  $SUDO tee "$NIX_CONF" > /dev/null <<EOF
substituters = $SUBSTITUTERS
trusted-public-keys = $TRUSTED_KEYS
trusted-users = root $(id -un)
experimental-features = nix-command flakes
EOF
  $SUDO systemctl restart nix-daemon 2>/dev/null \
    || $SUDO pkill -HUP nix-daemon 2>/dev/null \
    || echo "  (could not restart nix-daemon — reboot to apply)"
else
  echo ">>> $NIX_CONF already correct"
fi

echo ">>> Running nixos-rebuild switch --flake $REPO_DIR#framework"
exec $SUDO nixos-rebuild switch --flake "$REPO_DIR#framework"
