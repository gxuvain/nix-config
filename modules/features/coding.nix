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
      neovim-unwrapped
      qemu
      tree-sitter
      wrangler
    ];

    programs.git = {
      enable = true;
      ignores = [ ".DS_Store" ];
      includes = [
        {
          path = "${pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "delta";
            rev = "011516f5d14f66b771b3e716f29c77231e008c74";
            hash = "sha256-lztkxX9O41YossvRzpR7tqxMhDNT1Efy2JvkCwtsiXQ=";
          }}/catppuccin.gitconfig";
        }
      ];
      settings = {
        user = {
          name = "Gauvain Palanga";
          email = "gauvainpalanga@gmail.com";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO12IdgkNVV7DKPzi0t/rddp+ZKCLPA84nUzZzP0JFE4";
        };
        core.editor = "nvim";
        core.pager = "hunk pager";
        interactive.diffFilter = "delta --color-only";
        diff.tool = "hunk";
        difftool.hunk.cmd = ''hunk difftool "$LOCAL" "$REMOTE" "$MERGED"'';
        difftool.prompt = false;
        delta = {
          features = "catppuccin-mocha";
          line-numbers = true;
        };
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

    programs.delta = {
      enable = true;
      enableGitIntegration = false;
    };

    programs.lazygit = {
      enable = true;
      settings.git.diffRenderers = [
        {
          command = "delta --paging=never {{if gt .width 160}}--side-by-side{{end}}";
        }
      ];
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
