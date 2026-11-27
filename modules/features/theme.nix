{
  flake.modules.darwin.theme = {
    homebrew.casks = [
      "font-fantasque-sans-mono-nerd-font"
    ];
  };

  flake.modules.nixos.theme = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      noto-fonts
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [ "FantasqueSansM Nerd Font" ];
      sansSerif = [ "FantasqueSansM Nerd Font" ];
      serif = [ "FantasqueSansM Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  flake.modules.homeManager.theme = { config, lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      xdg.dataFile."wallpapers" = {
        source = ../../assets/wallpapers;
        recursive = true;
      };

      xdg.stateFile."dms/session.json".text = builtins.toJSON {
        wallpaperPath = "${config.xdg.dataHome}/wallpapers/wallpaper.png";
        nightModeUseIPLocation = true;
      };
    };
}
