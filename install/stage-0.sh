#!/usr/bin/env bash
set -euo pipefail

REPO_DIR=${REPO_DIR:-/tmp/.nixos}
DISK=${DISK:-nvme0n1}

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo -i) from the installer ISO." >&2
  exit 1
fi

if [[ ! -f $REPO_DIR/hosts/framework-13/disko.nix ]]; then
  echo "$REPO_DIR not found. Cloning..."
  git clone https://github.com/brian-xu/.nixos.git "$REPO_DIR"
fi

nix --experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest' -- \
  --mode destroy,format,mount "$REPO_DIR/hosts/framework-13/disko.nix"

echo
echo "Disk formatted and mounted at /mnt. Next:"
echo "  sudo bash $REPO_DIR/install/stage-1.sh"
