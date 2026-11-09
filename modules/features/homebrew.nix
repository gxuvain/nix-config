{ config, inputs, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.homebrew = { config, ... }: {
    nix-homebrew = {
      enable = true;
      autoMigrate = true;
      mutableTaps = false;
      user = username;
      extraEnv.XDG_CONFIG_HOME = config.home-manager.users.${username}.xdg.configHome;
      trust.taps = [ "anomalyco/tap" ];
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "anomalyco/homebrew-tap" = inputs.homebrew-anomalyco-tap;
      };
    };

    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = builtins.map (name: {
        inherit name;
        trusted = name == "anomalyco/homebrew-tap";
      }) (builtins.attrNames config.nix-homebrew.taps);
    };
  };
}
