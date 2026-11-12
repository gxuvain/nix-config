{
  flake.modules.darwin.ai = {
    homebrew.casks = [ "anomalyco/tap/hex" "chatgpt" "opencode-desktop" "t3-code" ];
  };

  flake.modules.homeManager.ai = { config, pkgs, ... }:
    let
      assets = "${config.home.homeDirectory}/Dev/nix-config/assets";
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      home.packages = with pkgs; [ opencode pi-coding-agent ];

      home.file.".pi/agent/settings.json".source =
        mkOutOfStoreSymlink "${assets}/pi/settings.json";
    };
}
