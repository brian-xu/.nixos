#!/usr/bin/env bash
# Stage 2: run from the freshly booted throwaway system (stage 1 output),
# as brian (sudo available). Applies the real flake configuration.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run as brian, not root (the script uses sudo where needed)." >&2
  exit 1
fi

echo ">>> Staging the sops age key at /etc/age/keys.txt"
echo "    (paste the key from Bitwarden, then Ctrl-D)"
sudo mkdir -p /etc/age
if [[ ! -s /etc/age/keys.txt ]]; then
  sudo tee /etc/age/keys.txt > /dev/null
  sudo chmod 600 /etc/age/keys.txt
else
  echo "    /etc/age/keys.txt already exists, skipping"
fi

echo ">>> Cloning the repo to ~/.nixos (disko-btrfs branch)"
if [[ -d ~/.nixos/.git ]]; then
  echo "    ~/.nixos already exists, pulling"
  git -C ~/.nixos fetch origin
  git -C ~/.nixos checkout disko-btrfs
  git -C ~/.nixos reset --hard origin/disko-btrfs
else
  git clone -b disko-btrfs https://github.com/brian-xu/.nixos.git ~/.nixos
fi

echo ">>> Applying the real system (builds onto disk-backed /nix)"
sudo nixos-rebuild switch --flake ~/.nixos#framework

echo
echo "Stage 2 complete. Set your real password:"
echo "  passwd"
echo "Then add this host's key to .sops.yaml and re-encrypt secrets"
echo "(see README.md)."
