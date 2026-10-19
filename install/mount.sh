#!/usr/bin/env bash
# Mount the disko-defined partitions at /mnt (run from the installer ISO, as root).
# Non-destructive: reuses the existing partitions/LUKS container as-is.
set -euo pipefail

REPO_DIR=${REPO_DIR:-/tmp/.nixos}
DISK=${DISK:-nvme0n1}

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo -i) from the installer ISO." >&2
  exit 1
fi

if [[ ! -f $REPO_DIR/hosts/framework-13/disko.nix ]]; then
  echo "$REPO_DIR not found. Cloning..."
  git clone -b disko-btrfs https://github.com/brian-xu/.nixos.git "$REPO_DIR"
fi

nix --experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest' -- \
  --mode mount "$REPO_DIR/hosts/framework-13/disko.nix"

echo
echo "Mounted at /mnt. Next:"
echo "  bash $REPO_DIR/install/stage-1.sh"
