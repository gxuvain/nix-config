{
  flake.modules.nixos.gnome-apps = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.nautilus
    ];

    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.gnome.sushi.enable = true;
    services.gnome.localsearch.enable = true;
    services.gnome.tinysparql.enable = true;
    programs.dconf.enable = true;
  };
}
