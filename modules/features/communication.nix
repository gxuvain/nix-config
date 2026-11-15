{
  flake.modules.darwin.communication = {
    homebrew.casks = [ "discord" ];
  };

  flake.modules.nixos.communication = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.discord ];
  };
}
