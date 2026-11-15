{ config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.security = {
    security.pam.services.sudo_local.touchIdAuth = true;
    homebrew.casks = [ "1password" "tailscale-app" ];
  };

  flake.modules.nixos.security = { pkgs, ... }: {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Lets 1Password use system authentication (polkit) to unlock.
      polkitPolicyOwners = [ username ];
    };

    services.tailscale.enable = true;
    environment.systemPackages = [ pkgs.trayscale ];
  };

  # Linux: use the 1Password SSH agent, like ~/.ssh/config does on the Mac.
  flake.modules.homeManager.security = { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*".identityAgent = "~/.1password/agent.sock";
      };

      home.sessionVariables.SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    };
}
