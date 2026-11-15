{
  flake.modules.darwin.launcher = {
    homebrew.casks = [ "tinycast" ];
  };

  # Vicinae: Raycast-like launcher for Linux.
  # Docs: https://docs.vicinae.com
  flake.modules.homeManager.launcher = { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.vicinae = {
        enable = true;
        systemd = {
          enable = true; # run the server in the background
          autoStart = true;
        };
        # Font installed by the theme feature (nerd-fonts.geist-mono).
        settings.font.normal.family = "GeistMono Nerd Font";
      };
    };
}
