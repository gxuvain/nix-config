{
  flake.modules.nixos.gnome-apps = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.nautilus # file explorer
    ];

    # Nautilus integration: trash, network/removable mounts, thumbnails, search.
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.gnome.sushi.enable = true; # quick preview (Space)
    services.gnome.localsearch.enable = true;
    services.gnome.tinysparql.enable = true;
    programs.dconf.enable = true;
  };
}
