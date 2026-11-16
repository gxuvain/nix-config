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
      polkitPolicyOwners = [ username ];
    };

    services.tailscale.enable = true;
    environment.systemPackages = [ pkgs.trayscale ];
  };

  flake.modules.homeManager.security = { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*".identityAgent = "~/.1password/agent.sock";
      };

      home.sessionVariables.SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";

      systemd.user.services =
        let
          trayApp = description: command: {
            Unit = {
              Description = description;
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" "dms.service" ];
            };
            Service = {
              ExecStart = command;
              Restart = "on-failure";
              RestartSec = 2;
            };
            Install.WantedBy = [ "graphical-session.target" ];
          };
        in
        {
          _1password = trayApp "1Password" "/run/current-system/sw/bin/1password --silent";
          trayscale = trayApp "Trayscale" "${lib.getExe pkgs.trayscale} --hide-window";
        };
    };
}
