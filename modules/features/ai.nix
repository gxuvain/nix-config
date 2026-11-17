{
  flake.modules.darwin.ai = { lib, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";
    homebrew.casks = [ "anomalyco/tap/hex" "claude" "opencode-desktop" "t3-code" ];
  };

  flake.modules.nixos.ai = { lib, pkgs, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";
    environment.systemPackages = with pkgs; [ opencode-desktop t3code ];
  };

  flake.modules.homeManager.ai = { config, pkgs, ... }:
    let
      assets = "${config.home.homeDirectory}/Dev/nix-config/assets";
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      home.packages = with pkgs; [ claude-code opencode pi-coding-agent ];

      home.file.".pi/agent/settings.json".source =
        mkOutOfStoreSymlink "${assets}/pi/settings.json";
      home.file.".pi/agent/themes/catppuccin-mocha.json".source =
        mkOutOfStoreSymlink "${assets}/pi/themes/catppuccin-mocha.json";
    };
}
