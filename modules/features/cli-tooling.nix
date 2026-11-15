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
      imagemagick
      jq
      ripgrep
      unzip
    ]
    # Linux only: macOS already has `cc` (Xcode CLT clang), and bubblewrap is Linux-only.
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      bubblewrap # bwrap
      gcc # cc
    ];

    programs.fzf.enable = true;
    programs.zoxide.enable = true;
  };
}
