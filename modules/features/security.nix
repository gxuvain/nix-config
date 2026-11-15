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

      # Start 1Password (SSH agent) and Trayscale minimized to the tray on login.
      systemd.user.services =
        let
          trayApp = description: command: {
            Unit = {
              Description = description;
              PartOf = [ "graphical-session.target" ];
              # After DMS so the tray (StatusNotifier) is ready.
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
          # From programs._1password-gui (NixOS), which also sets up its helper wrappers.
          _1password = trayApp "1Password" "/run/current-system/sw/bin/1password --silent";
          trayscale = trayApp "Trayscale" "${lib.getExe pkgs.trayscale} --hide-window";
        };
    };
}
