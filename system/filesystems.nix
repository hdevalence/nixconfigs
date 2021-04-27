{ config, pkgs, lib, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "elevator=none" ];
  services.zfs.trim.enable = true;

  fileSystems."/" =
    { device = "pool/system/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW010T8_BTNH00400YTJ1P0B-part1";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "pool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home/hdevalence" =
    { device = "pool/home/hdevalence";
      fsType = "zfs";
    };

  fileSystems."/home/hdevalence/data" =
    { device = "data/hdevalence";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/root" =
    { device = "pool/home/root";
      fsType = "zfs";
    };

   swapDevices = [ ];
}
