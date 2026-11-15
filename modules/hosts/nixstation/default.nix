{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
in
{
  flake.nixosConfigurations.nixstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.ai
      nixos.coding
      nixos.communication
      nixos.music
      nixos.security
      nixos.nix
      nixos.nixstationConfiguration
      nixos.nixstationHardware
      nixos.sound
      nixos.theme
      nixos.window-manager

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "before-nix";
        home-manager.users.${username}.imports = [
          hm.ai
          hm.browser
          hm.gxuvain
          hm.cli-tooling
          hm.coding
          hm.security
          hm.sound
          hm.terminal
          hm.window-manager
        ];
      }
    ];
  };
}
