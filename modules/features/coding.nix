{ inputs, ... }:
{
  flake.modules.darwin.coding = {
    homebrew.brews = [
      "cloudflare-wrangler"
      "qemu"
    ];
    homebrew.casks = [
      "docker-desktop"
      "utm"
    ];
  };

  flake.modules.homeManager.coding = { config, lib, pkgs, ... }: {
    home.packages = with pkgs; [
      devenv
      gh
      helix
      just
      lazygit
      tree-sitter
    ] ++ [
      inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs.git = {
      enable = true;
      ignores = [ ".DS_Store" ];
      settings = {
        user = {
          name = "Gauvain Palanga";
          email = "gauvainpalanga@gmail.com";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO12IdgkNVV7DKPzi0t/rddp+ZKCLPA84nUzZzP0JFE4";
        };
        core.editor = "hx";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
        gpg.ssh.program = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        );
        commit.gpgsign = true;
      };
    };

    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink (
      "${config.home.homeDirectory}/Dev/nix-config/assets/nvim"
    );

    programs.zsh.initContent = lib.mkOrder 1100 ''
      eval "$(opam env)"
    '';

    programs.mise = {
      enable = true;
      globalConfig.tools = {
        bun = "latest";
        node = "latest";
        opam = "latest";
        python = "latest";
        pnpm = "latest";
        rust = "latest";
        uv = "latest";
      };
    };
  };
}
