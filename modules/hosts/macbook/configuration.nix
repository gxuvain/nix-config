{ config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.macbookConfiguration = {
    nixpkgs.hostPlatform = "aarch64-darwin";
    users.users.${username}.home = "/Users/${username}";

    system.primaryUser = username;
    system.stateVersion = 6;

    system.defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.5;
        tilesize = 53;
        largesize = 74;
        magnification = true;
        show-recents = false;
      };

      finder = {
        FXPreferredViewStyle = "Nlsv";
        NewWindowTarget = "Home";
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      WindowManager = {
        EnableTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = false;
      };
    };
  };
}
