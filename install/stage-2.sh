#!/usr/bin/env bash
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}

if [[ $EUID -eq 0 ]]; then
  echo "Run as brian, not root (the script uses sudo where needed)." >&2
  exit 1
fi

run_git() {
  if command -v git > /dev/null 2>&1; then
    git "$@"
  else
    nix-shell -p git --run "git $*"
  fi
}

if ! grep -q 'brian-xu.cachix.org' /etc/nix/nix.conf 2>/dev/null; then
  echo ">>> Adding cachix substituters to /etc/nix/nix.conf and restarting nix-daemon"
  sudo mkdir -p /etc/nix
  sudo tee /etc/nix/nix.conf > /dev/null <<'EOF'
substituters = https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=
trusted-users = root brian
EOF
  sudo systemctl restart nix-daemon
fi

echo ">>> Fetching the repo to $REPO_DIR"
if [[ -d $REPO_DIR/.git ]]; then
  echo "    $REPO_DIR already exists, updating"
  run_git -C "$REPO_DIR" fetch origin
  run_git -C "$REPO_DIR" remote set-head origin -a
  run_git -C "$REPO_DIR" reset --hard origin/HEAD
else
  run_git clone https://github.com/brian-xu/.nixos.git "$REPO_DIR"
fi

echo ">>> Applying the real system (builds onto disk-backed /nix)"
sudo nixos-rebuild switch --flake "$REPO_DIR#framework"

echo
echo "Stage 2 complete. Set your real password:"
echo "  passwd"
