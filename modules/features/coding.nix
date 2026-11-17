{ config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.coding = {
    homebrew.casks = [ "docker-desktop" ];
  };

  flake.modules.nixos.coding = {
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = [ "docker" ];

    programs.nix-ld.enable = true;
  };

  flake.modules.homeManager.coding = { config, lib, pkgs, ... }: {
    home.packages = with pkgs; [
      devenv
      gh
      just
      lazygit
      neovim-unwrapped
      qemu
      tree-sitter
      wrangler
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
        core.editor = "nvim";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
        gpg.ssh.program =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            "/run/current-system/sw/bin/op-ssh-sign";
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
      globalConfig.settings.all_compile = false;
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
