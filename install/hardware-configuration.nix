{ ... }:
{
  fileSystems."/" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [
      "subvol=/root"
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/home" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [
      "subvol=/home"
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/nix" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [
      "subvol=/nix"
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/boot";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };
  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-partlabel/disk-nvme0n1-luks";
    allowDiscards = true;
  };
  swapDevices = [
    {
      device = "/dev/disk/by-partlabel/disk-nvme0n1-swap";
      randomEncryption = true;
    }
  ];
}
