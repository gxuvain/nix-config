{
  flake.modules.darwin.nix = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };

  flake.modules.nixos.nix = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.trusted-users = [ "@wheel" ];
  };
}
