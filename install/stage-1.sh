#!/usr/bin/env bash
# Stage 1: run from the minimal installer ISO, as root, after disko has
# formatted and mounted the target at /mnt.
#
# Installs a minimal throwaway system whose closure fits the ISO's RAM-backed
# /nix store. The real flake is applied by install/stage-2.sh after first boot.
set -euo pipefail

MNT=/mnt

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo -i) from the installer ISO." >&2
  exit 1
fi

if ! mountpoint -q "$MNT"; then
  echo "$MNT is not a mountpoint." >&2
  echo "Run disko first, e.g.:" >&2
  echo "  nix --experimental-features 'nix-command flakes' \\"
  echo "    run 'github:nix-community/disko/latest' -- \\"
  echo "    --mode destroy,format,mount /tmp/.nixos/hosts/framework-13/disko.nix" >&2
  exit 1
fi

echo ">>> Writing $MNT/etc/nixos/hardware-configuration.nix"
mkdir -p "$MNT/etc/nixos"

cat > "$MNT/etc/nixos/hardware-configuration.nix" <<'EOF'
{ ... }:
{
  fileSystems."/" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=/root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=/home" "compress=zstd" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=/nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };
  boot.initrd.luks.devices.crypted = {
    device = "/dev/nvme0n1p3";
    allowDiscards = true;
  };
  swapDevices = [ { device = "/dev/nvme0n1p2"; randomEncryption = true; } ];
}
EOF

echo ">>> Writing $MNT/etc/nixos/configuration.nix"
cat > "$MNT/etc/nixos/configuration.nix" <<'EOF'
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # Wifi firmware (Framework 13 uses mt7921e, in-tree driver, firmware needed)
  # so stage 2 can clone/rebuild over wifi after first boot.
  hardware.enableRedistributableFirmware = true;

  users.users.brian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "install";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # The flake's nix.settings only applies after stage 2's rebuild; without
  # these the stage-2 build (on this throwaway) substitutes from nothing and
  # builds the entire closure from source.
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://brian-xu.cachix.org"
    "https://niri.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g="
    "brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4="
    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
  ];
  system.stateVersion = "26.05";
}
EOF

echo ">>> Running nixos-install (builds the minimal system, installs systemd-boot)"
nixos-install --root "$MNT" --no-root-password

echo
echo "Stage 1 complete. Reboot (remove the USB), unlock LUKS, log in as brian/install,"
echo "then run stage 2:"
echo "  curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/stage-2.sh | sudo bash"
echo "(or clone the repo and run: sudo bash install/stage-2.sh)"
