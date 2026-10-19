#!/usr/bin/env bash
set -euo pipefail

MNT=/mnt
REPO_DIR=${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}
STAGE_DIR=$(cd "$(dirname "$0")" && pwd)

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo -i) from the installer ISO." >&2
  exit 1
fi

if ! mountpoint -q "$MNT"; then
  echo "$MNT is not a mountpoint." >&2
  echo "Run disko first, e.g.:" >&2
  echo "  nix --experimental-features 'nix-command flakes' \\"
  echo "    run 'github:nix-community/disko/latest' -- \\"
  echo "    --mode destroy,format,mount $REPO_DIR/hosts/framework-13/disko.nix" >&2
  exit 1
fi

echo ">>> Copying stage-1 configuration to $MNT/etc/nixos"
mkdir -p "$MNT/etc/nixos"
install -m 0644 \
  "$STAGE_DIR/hardware-configuration.nix" \
  "$STAGE_DIR/configuration.nix" \
  "$MNT/etc/nixos/"

echo ">>> Running nixos-install (builds the minimal system, installs systemd-boot)"
nixos-install --root "$MNT" --no-root-password

echo
echo "Stage 1 complete. Reboot (remove the USB), unlock LUKS, log in as brian/install,"
echo "then run stage 2:"
echo "  curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/install/stage-2.sh | bash"
echo "(or clone the repo and run: bash install/stage-2.sh)"
