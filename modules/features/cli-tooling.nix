{
  flake.modules.darwin.cli-tooling = {
    homebrew.brews = [ "mole" ];
  };

  flake.modules.homeManager.cli-tooling = { pkgs, ... }: {
    home.packages = with pkgs; [
      eza
      fastfetch
      fd
      imagemagick
      jq
      ripgrep
    ];

    programs.fzf.enable = true;
    programs.zoxide.enable = true;
  };
}
