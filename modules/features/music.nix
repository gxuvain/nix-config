{
  flake.modules.darwin.music = {
    homebrew.casks = [ "spotify" ];
  };

  flake.modules.nixos.music = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.spotify ];

    networking.firewall.allowedTCPPorts = [ 57621 ];
    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
}
