{ config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.nixos.nixstationConfiguration = { config, pkgs, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

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

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 10;

      extraEntries = ''
        /Windows
            protocol: efi
            path: guid(ccaf4cb7-e117-45e5-a8e7-355af29c1058):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKMUBSk7di22dPU7Jv6Kh3wBS6KhWZR5olZ9aYOkTeh"
      ];
    };

    programs.zsh.enable = true;

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "no";
    };

    environment.systemPackages = [ pkgs.git ];

    system.stateVersion = "26.05";
  };
}
