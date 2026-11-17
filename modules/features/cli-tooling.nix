{
  flake.modules.darwin.cli-tooling = {
    homebrew.brews = [ "mole" ];
  };

  flake.modules.homeManager.cli-tooling = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      eza
      fastfetch
      fd
      gnumake
      hunk
      imagemagick
      jq
      ripgrep
      unzip
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      bubblewrap
      gcc
    ];

    programs.fzf.enable = true;
    programs.zoxide.enable = true;

    xdg.configFile."hunk/config.toml".text = ''
      theme = "catppuccin-mocha"
      agent_notes = true
    '';
  };
}
