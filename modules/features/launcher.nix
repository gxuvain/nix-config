{
  flake.modules.darwin.launcher = {
    homebrew.casks = [ "tinycast" ];
  };

  flake.modules.homeManager.launcher = { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
        };
        settings = {
          font.normal.family = "FantasqueSansM Nerd Font";
          theme = {
            dark.name = "catppuccin-mocha";
            light.name = "catppuccin-mocha";
          };
        };
      };
    };
}
