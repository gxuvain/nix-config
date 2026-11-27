{ inputs, ... }:
{
  flake.modules.darwin.terminal = {
    homebrew.casks = [ "ghostty" ];
  };

  flake.modules.homeManager.terminal = { config, pkgs, ... }: {
    home.packages = [
      inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink (
      "${config.home.homeDirectory}/Dev/nix-config/assets/herdr/config.toml"
    );

    programs.ghostty = {
      enable = true;
      package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else null;
      settings = {
        theme = "Catppuccin Mocha";
        font-family = "FantasqueSansM Nerd Font";
        font-thicken = true;
        font-size = 17;
      };

    };

    programs.zsh = {
      enable = true;
      history.path = "${config.home.homeDirectory}/.zsh_history";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        c = "clear";
        ls = "eza --icons";
        ll = "eza -l --icons";
      };

      initContent = ''
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      '';
    };

    programs.starship.enable = true;
  };
}
