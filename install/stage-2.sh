#!/usr/bin/env bash
# Stage 2: run from the freshly booted throwaway system (stage 1 output),
# as brian. Applies the real flake configuration.
#
# Usage (download first — do NOT pipe into bash, the script reads stdin):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/stage-2.sh -o /tmp/stage-2.sh
#   bash /tmp/stage-2.sh
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
BRANCH=${BRANCH:-disko-btrfs}

if [[ $EUID -eq 0 ]]; then
  echo "Run as brian, not root (the script uses sudo where needed)." >&2
  exit 1
fi

# Read the age key from the terminal even if stdin is redirected.
read_key() {
  local keyfile=$1
  if [[ -t 0 ]]; then
    sudo tee "$keyfile" > /dev/null
  else
    sudo tee "$keyfile" > /dev/null < /dev/tty
  fi
  sudo chmod 600 "$keyfile"
}

echo ">>> Staging the sops age key at /etc/age/keys.txt"
sudo mkdir -p /etc/age
if [[ -s /etc/age/keys.txt ]]; then
  echo "    /etc/age/keys.txt already exists, skipping"
else
  echo "    Paste the key from Bitwarden, then press Enter and Ctrl-D:"
  read_key /etc/age/keys.txt
  if [[ ! -s /etc/age/keys.txt ]]; then
    echo "Empty key file — aborting." >&2
    exit 1
  fi
fi

echo ">>> Fetching the repo to $REPO_DIR (branch $BRANCH)"
if [[ -d $REPO_DIR/.git ]]; then
  echo "    $REPO_DIR already exists, updating"
  git -C "$REPO_DIR" fetch origin
  git -C "$REPO_DIR" checkout "$BRANCH"
  git -C "$REPO_DIR" reset --hard "origin/$BRANCH"
else
  git clone -b "$BRANCH" https://github.com/brian-xu/.nixos.git "$REPO_DIR"
fi

echo ">>> Applying the real system (builds onto disk-backed /nix)"
sudo nixos-rebuild switch --flake "$REPO_DIR#framework"

echo
echo "Stage 2 complete. Set your real password:"
echo "  passwd"
echo "Then add this host's key to .sops.yaml and re-encrypt secrets"
echo "(see README.md)."
