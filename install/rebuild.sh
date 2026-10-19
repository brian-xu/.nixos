#!/usr/bin/env bash
# rebuild.sh: apply the real flake with working substitution, from the
# throwaway system (stage 1 output) or any booted system.
#
# Handles the trust problem that causes "ignoring the following substituters":
# substituters are only honored for trusted users / a trusting daemon. Running
# as root always works; otherwise the daemon's nix.conf is fixed first.
#
# Usage (as brian or root, on the booted throwaway):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/rebuild.sh -o /tmp/rebuild.sh
#   bash /tmp/rebuild.sh
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
BRANCH=${BRANCH:-disko-btrfs}
NIX_CONF=/etc/nix/nix.conf

SUBSTITUTERS="https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org"
TRUSTED_KEYS="cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
OPTS=(--option substituters "$SUBSTITUTERS" --option trusted-public-keys "$TRUSTED_KEYS")

if [[ ! -d $REPO_DIR/.git ]]; then
  echo ">>> $REPO_DIR missing — clone it first (stage-2.sh does this) or set REPO_DIR" >&2
  exit 1
fi

SUDO=""
if [[ $EUID -ne 0 ]]; then
  SUDO="sudo"
fi

# Root is always trusted: run the rebuild as root directly, no nix.conf edits.
if [[ $EUID -eq 0 ]]; then
  echo ">>> Running nixos-rebuild as root (unconditionally trusted)"
  exec nixos-rebuild switch --flake "$REPO_DIR#framework" "${OPTS[@]}"
fi

# Non-root: check whether the daemon trusts us; if not, fix nix.conf as root.
trusted=false
if $SUDO grep -q '^trusted-users' "$NIX_CONF" 2>/dev/null \
   && $SUDO grep -Eq '^trusted-users.*\b'"$(id -un)"'\b' "$NIX_CONF" 2>/dev/null; then
  trusted=true
fi

if [[ $trusted != true ]]; then
  echo ">>> Daemon does not trust $(id -un); updating $NIX_CONF and restarting nix-daemon"
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
EOF
  $SUDO systemctl restart nix-daemon
  echo "    nix-daemon restarted with new config"
fi

echo ">>> Running nixos-rebuild as $(id -un) (trusted)"
exec $SUDO nixos-rebuild switch --flake "$REPO_DIR#framework" "${OPTS[@]}"
