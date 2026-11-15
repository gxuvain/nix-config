{
  flake.modules.darwin.music = {
    homebrew.casks = [ "spotify" ];
  };

  flake.modules.nixos.music = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.spotify ];

    # Spotify Connect / local device discovery.
    networking.firewall.allowedTCPPorts = [ 57621 ];
    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
}
