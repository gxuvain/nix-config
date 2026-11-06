{ inputs, ... }:
{
  flake.modules.darwin.terminal = {
    homebrew.casks = [ "ghostty" ];
  };

  flake.modules.homeManager.terminal = { config, pkgs, ... }: {
    home.packages = [
      pkgs.tmux
      inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."tmux/tmux.conf".text = builtins.readFile ../../assets/tmux.conf + ''
      run-shell "${pkgs.tmuxPlugins.catppuccin.rtp}"
    '';

    programs.ghostty = {
      enable = true;
      package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else null;
      settings = {
        theme = "Catppuccin Mocha";
        background = "#08080e";
        font-family = "GeistMono Nerd Font";
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
