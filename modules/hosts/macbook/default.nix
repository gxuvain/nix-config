{ inputs, config, ... }:
let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
in
{
  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew

      darwin.ai
      darwin.browser
      darwin.cli-tooling
      darwin.coding
      darwin.communication
      darwin.homebrew
      darwin.launcher
      darwin.macbookConfiguration
      darwin.music
      darwin.nix
      darwin.security
      darwin.terminal
      darwin.theme
      darwin.window-manager

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "before-nix";
        home-manager.users.${username}.imports = [
          hm.ai
          hm.gxuvain
          hm.cli-tooling
          hm.coding
          hm.terminal
        ];
      }
    ];
  };
}
