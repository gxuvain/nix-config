{ config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.nixos.nixstationConfiguration = { config, pkgs, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    nixpkgs.config.allowUnfree = true;

    # NVIDIA RTX 3060 Ti (Ampere): proprietary driver with the open kernel modules.
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Niri on NVIDIA: stop the driver from keeping a huge VRAM buffer pool.
    # https://niri-wm.github.io/niri/Nvidia.html
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
      builtins.toJSON {
        rules = [
          {
            pattern = { feature = "procname"; matches = "niri"; };
            profile = "Limit Free Buffer Pool On Wayland Compositors";
          }
        ];
        profiles = [
          {
            name = "Limit Free Buffer Pool On Wayland Compositors";
            settings = [ { key = "GLVidHeapReuseRatio"; value = 0; } ];
          }
        ];
      };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Dual boot: Windows lives on another disk (sdb) with its own ESP, so
    # systemd-boot can't detect it. The EDK2 shell entry is used to find its
    # device handle (`map -c`), then Windows gets its own menu entry.
    boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
    # boot.loader.systemd-boot.windows."11".efiDeviceHandle = "HD?b"; # TODO: set from `map -c`

    # Windows keeps the hardware clock in local time; match it to avoid clock drift on switch.
    time.hardwareClockInLocalTime = true;

    networking.hostName = "nixstation";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    services.xserver.xkb = {
      layout = "fr";
      variant = "azerty";
    };
    console.keyMap = "fr";

    hardware.enableRedistributableFirmware = true;

    users.users.${username} = {
      isNormalUser = true;
      description = "Gauvain Palanga";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # "MacBook Air SSH Key" (stored in 1Password)
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKMUBSk7di22dPU7Jv6Kh3wBS6KhWZR5olZ9aYOkTeh"
      ];
    };

    programs.zsh.enable = true;

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "no";
    };

    # TODO: remove once the machine is fully set up.
    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = [ pkgs.git ];

    # Must match the version NixOS was installed with (see generated /etc/nixos/configuration.nix).
    system.stateVersion = "26.05";
  };
}
