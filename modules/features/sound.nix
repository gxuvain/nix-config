{
  flake.modules.nixos.sound = { pkgs, ... }: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = [ pkgs.pwvucontrol ];
  };

  # EasyEffects: system-wide EQ/effects on top of PipeWire (IEM tuning).
  # Runs in the background, started with the graphical session.
  flake.modules.homeManager.sound = { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      services.easyeffects.enable = true;
    };
}
