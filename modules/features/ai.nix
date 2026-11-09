{
  flake.modules.darwin.ai = {
    homebrew.brews = [
      "pi-coding-agent"
      "anomalyco/tap/opencode-v2"
    ];
    homebrew.casks = [ "chatgpt" "opencode-desktop" "t3-code" ];
  };

  flake.modules.homeManager.ai = { config, ... }:
    let
      assets = "${config.home.homeDirectory}/Dev/nix-config/assets";
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      home.file.".pi/agent/settings.json".source =
        mkOutOfStoreSymlink "${assets}/pi/settings.json";
    };
}
