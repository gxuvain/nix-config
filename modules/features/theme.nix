{
  flake.modules.darwin.theme = {
    homebrew.casks = [
      "font-geist-mono-nerd-font"
      "font-iosevka-term-nerd-font"
    ];
  };

  flake.modules.nixos.theme = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.geist-mono
      nerd-fonts.iosevka-term
      inter
      noto-fonts
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [ "GeistMono Nerd Font" ];
      sansSerif = [ "Inter" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
