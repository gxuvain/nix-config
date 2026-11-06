{ lib, ... }:
{
  options.flake.username = lib.mkOption {
    type = lib.types.str;
    default = "gxuvain";
    description = "User shared by the host and Home Manager configurations.";
  };

  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
  };

  config.systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];

  config.perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt;
  };
}
