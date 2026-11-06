{
  flake.modules.darwin.security = {
    security.pam.services.sudo_local.touchIdAuth = true;
    homebrew.casks = [ "1password" "tailscale-app" ];
  };
}
