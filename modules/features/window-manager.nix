{ config, ... }:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.window-manager = {
    homebrew.casks = [ "rectangle" ];
  };

  flake.modules.nixos.window-manager = { pkgs, ... }: {
    programs.niri.enable = true;

    services.displayManager.dux-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/${username}";
    };

    environment.systemPackages = [ pkgs.xwayland-satellite ];

    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    hardware.bluetooth.enable = true;
    security.polkit.enable = true;
  };

  flake.modules.homeManager.window-manager = { lib, pkgs, ... }:
    let
      dms = args: { spawn = [ "dms" "ipc" "call" ] ++ args; };
      titled = title: action: lib.recursiveUpdate action { _props.hotkey-overlay-title = title; };
      noRepeat = action: lib.recursiveUpdate action { _props.repeat = false; };
      whenLocked = action: lib.recursiveUpdate action { _props.allow-when-locked = true; };

      azertyNumbers = [
        "ampersand" "eacute" "quotedbl" "apostrophe" "parenleft"
        "minus" "egrave" "underscore" "ccedilla"
      ];
      workspaceBinds = lib.mergeAttrsList (lib.imap1 (i: key: {
        "Mod+${key}".focus-workspace = i;
        "Mod+Shift+${key}".move-column-to-workspace = i;
      }) azertyNumbers);

      spring = damping-ratio: stiffness: epsilon: {
        spring._props = { inherit damping-ratio stiffness epsilon; };
      };

      matchAppIds = ids: map (id: { match._props.app-id = id; }) ids;

      dmsIncludes = [
        "colors" "layout" "alttab" "binds" "outputs"
        "cursor" "input" "windowrules" "wpblur"
      ];
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      wayland.windowManager.niri = {
        enable = true;
        systemd.enable = false;
        portalPackage = null;
        xwaylandSatellitePackage = null;

        settings = {
          config-notification.disable-failed = { };
          gestures.hot-corners.off = { };

          input = {
            keyboard = {
              xkb = {
                layout = "fr";
                variant = "azerty";
              };
              numlock = { };
            };
            touchpad = {
              tap = { };
              natural-scroll = { };
            };
            focus-follows-mouse._props.max-scroll-amount = "0%";
          };

          layout = {
            gaps = 12;
            background-color = "transparent";
            center-focused-column = "never";
            preset-column-widths._children = [
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];
            default-column-width.proportion = 0.5;
            focus-ring = {
              width = 2;
              active-color = "#cba6f7";
              inactive-color = "#45475a";
            };
            border.off = { };
            shadow = {
              softness = 30;
              spread = 5;
              offset._props = { x = 0; y = 5; };
              color = "#0007";
            };
          };

          overview.workspace-shadow.off = { };
          environment.XDG_CURRENT_DESKTOP = "niri";
          hotkey-overlay.skip-at-startup = { };
          prefer-no-csd = { };
          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
          debug.honor-xdg-activation-with-invalid-serial = { };

          animations = {
            workspace-switch = spring 0.80 523 0.0001;
            horizontal-view-movement = spring 0.85 423 0.0001;
            window-movement = spring 0.75 323 0.0001;
            window-resize = spring 0.85 423 0.0001;
            overview-open-close = spring 0.85 800 0.0001;
            window-open = { duration-ms = 150; curve = "ease-out-expo"; };
            window-close = { duration-ms = 150; curve = "ease-out-quad"; };
          };

          recent-windows.binds = {
            "Alt+Tab".next-window._props.scope = "output";
            "Alt+Shift+Tab".previous-window._props.scope = "output";
          };

          _children = [
            {
              output = {
                _args = [ "ASUSTek COMPUTER INC XG27AQWMG TCLMTF070804" ];
                mode = "2560x1440@279.961";
                scale = 1;
                position._props = { x = 0; y = 0; };
              };
            }

            {
              layer-rule = {
                match._props.namespace = "^quickshell$";
                place-within-backdrop = true;
              };
            }

            {
              window-rule = {
                geometry-corner-radius = 12;
                clip-to-geometry = true;
              };
            }
            {
              window-rule = {
                _children = matchAppIds [ "com.mitchellh.ghostty" ];
                draw-border-with-background = false;
              };
            }
            {
              window-rule = {
                _children = matchAppIds [
                  "^org\\.gnome\\.Calculator$"
                  "^blueman-manager$"
                  "^xdg-desktop-portal$"
                  "^com\\.saivert\\.pwvucontrol$"
                ] ++ [ { match._props.title = "^[Pp]icture[- ]in[- ][Pp]icture$"; } ];
                open-floating = true;
              };
            }
            {
              window-rule = {
                match._props = {
                  app-id = "^steam$";
                  title = "^notificationtoasts_\\d+_desktop$";
                };
                default-floating-position._props = { x = 10; y = 10; relative-to = "bottom-right"; };
                open-focused = false;
              };
            }
          ];

          binds = workspaceBinds // {
            "Mod+O" = noRepeat { toggle-overview = { }; };
            "Mod+Tab" = noRepeat { toggle-overview = { }; };
            "Mod+Shift+Comma" = titled "Keyboard Shortcuts" (dms [ "keybinds" "toggle" "niri" ]);

            "Mod+Return" = titled "Open Ghostty" { spawn = "ghostty"; };
            "Mod+T" = titled "Open Ghostty" { spawn = "ghostty"; };
            "Mod+Space" = titled "Application Launcher" (noRepeat { spawn = [ "vicinae" "toggle" ]; });
            "Mod+V" = titled "Clipboard Manager" (dms [ "clipboard" "toggle" ]);
            "Mod+M" = titled "Media" (dms [ "dash" "toggle" "media" ]);
            "Mod+X" = titled "Power Menu" (dms [ "powermenu" "toggle" ]);
            "Mod+A" = titled "Control Center" (dms [ "control-center" "toggle" ]);
            "Mod+D" = titled "Dash" (dms [ "dash" "toggle" "" ]);
            "Mod+Shift+C" = titled "Color Picker" (dms [ "color-picker" "toggle" ]);
            "Mod+Alt+N" = titled "Night Mode" (dms [ "night" "toggle" ]);
            "Mod+Alt+I" = titled "Idle Inhibit" (dms [ "inhibit" "toggle" ]);
            "Mod+Comma" = titled "Settings" (dms [ "settings" "focusOrToggle" ]);
            "Mod+Y" = titled "Browse Wallpapers" (dms [ "dash" "toggle" "wallpaper" ]);
            "Mod+N" = titled "Notepad" (dms [ "notepad" "toggle" ]);
            "Mod+Ctrl+N" = titled "Notification Center" (dms [ "notifications" "toggle" ]);

            "Mod+Alt+L" = titled "Lock Screen" (dms [ "lock" "lock" ]);
            "Mod+Shift+E".quit = { };
            "Ctrl+Alt+Delete" = titled "Task Manager" (dms [ "processlist" "focusOrToggle" ]);

            "XF86AudioRaiseVolume" = whenLocked (dms [ "audio" "increment" "3" ]);
            "XF86AudioLowerVolume" = whenLocked (dms [ "audio" "decrement" "3" ]);
            "XF86AudioMute" = whenLocked (dms [ "audio" "mute" ]);
            "XF86AudioMicMute" = whenLocked (dms [ "audio" "micmute" ]);
            "XF86AudioPlay" = whenLocked (dms [ "mpris" "playPause" ]);
            "XF86AudioPause" = whenLocked (dms [ "mpris" "playPause" ]);
            "XF86AudioPrev" = whenLocked (dms [ "mpris" "previous" ]);
            "XF86AudioNext" = whenLocked (dms [ "mpris" "next" ]);

            "Mod+Q" = noRepeat { close-window = { }; };
            "Mod+F".maximize-column = { };
            "Mod+Shift+F".fullscreen-window = { };
            "Mod+Shift+T".toggle-window-floating = { };
            "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
            "Mod+W".toggle-column-tabbed-display = { };

            "Mod+H".focus-column-left = { };
            "Mod+J".focus-window-down = { };
            "Mod+K".focus-window-up = { };
            "Mod+L".focus-column-right = { };
            "Mod+Left".focus-column-left = { };
            "Mod+Down".focus-window-down = { };
            "Mod+Up".focus-window-up = { };
            "Mod+Right".focus-column-right = { };

            "Mod+Shift+H".move-column-left = { };
            "Mod+Shift+J".move-window-down = { };
            "Mod+Shift+K".move-window-up = { };
            "Mod+Shift+L".move-column-right = { };
            "Mod+Shift+Left".move-column-left = { };
            "Mod+Shift+Down".move-window-down = { };
            "Mod+Shift+Up".move-window-up = { };
            "Mod+Shift+Right".move-column-right = { };

            "Mod+Home".focus-column-first = { };
            "Mod+End".focus-column-last = { };
            "Mod+Ctrl+Home".move-column-to-first = { };
            "Mod+Ctrl+End".move-column-to-last = { };

            "Mod+Ctrl+H".focus-monitor-left = { };
            "Mod+Ctrl+J".focus-monitor-down = { };
            "Mod+Ctrl+K".focus-monitor-up = { };
            "Mod+Ctrl+L".focus-monitor-right = { };
            "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
            "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
            "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
            "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

            "Mod+U".focus-workspace-down = { };
            "Mod+I".focus-workspace-up = { };
            "Mod+Page_Down".focus-workspace-down = { };
            "Mod+Page_Up".focus-workspace-up = { };
            "Mod+Ctrl+U".move-column-to-workspace-down = { };
            "Mod+Ctrl+I".move-column-to-workspace-up = { };
            "Mod+Shift+U".move-workspace-down = { };
            "Mod+Shift+I".move-workspace-up = { };
            "Mod+Alt+R" = titled "Rename Workspace" (dms [ "workspace-rename" "open" ]);

            "Mod+WheelScrollDown" = { _props.cooldown-ms = 150; focus-workspace-down = { }; };
            "Mod+WheelScrollUp" = { _props.cooldown-ms = 150; focus-workspace-up = { }; };
            "Mod+Ctrl+WheelScrollDown" = { _props.cooldown-ms = 150; move-column-to-workspace-down = { }; };
            "Mod+Ctrl+WheelScrollUp" = { _props.cooldown-ms = 150; move-column-to-workspace-up = { }; };
            "Mod+Shift+WheelScrollDown".focus-column-right = { };
            "Mod+Shift+WheelScrollUp".focus-column-left = { };

            "Mod+Semicolon".consume-or-expel-window-left = { };
            "Mod+Colon".consume-or-expel-window-right = { };
            "Mod+Exclam".expel-window-from-column = { };

            "Mod+R".switch-preset-column-width = { };
            "Mod+Shift+R".switch-preset-window-height = { };
            "Mod+Ctrl+R".reset-window-height = { };
            "Mod+Ctrl+F".expand-column-to-available-width = { };
            "Mod+C".center-column = { };
            "Mod+Ctrl+C".center-visible-columns = { };
            "Mod+parenright".set-column-width = "-10%";
            "Mod+equal".set-column-width = "+10%";
            "Mod+Shift+parenright".set-window-height = "-10%";
            "Mod+Shift+equal".set-window-height = "+10%";

            "Print" = titled "Screenshot: Region" { spawn = [ "dms" "screenshot" ]; };
            "Ctrl+Print" = titled "Screenshot: Full Screen" { spawn = [ "dms" "screenshot" "full" ]; };
            "Alt+Print" = titled "Screenshot: Window" { spawn = [ "dms" "screenshot" "window" ]; };

            "Mod+Escape" = { _props.allow-inhibiting = false; toggle-keyboard-shortcuts-inhibit = { }; };
            "Mod+Shift+P".power-off-monitors = { };
          };
        };

        extraConfig = lib.concatMapStringsSep "\n" (f: ''include optional=true "dms/${f}.kdl"'') dmsIncludes;
      };

      home.pointerCursor = {
        enable = true;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
        gtk.enable = true;
      };

      gtk = {
        enable = true;
        colorScheme = "dark";
        font = {
          name = "FantasqueSansM Nerd Font";
          size = 11;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        font-name = "FantasqueSansM Nerd Font 11";
        document-font-name = "FantasqueSansM Nerd Font 11";
        monospace-font-name = "FantasqueSansM Nerd Font 11";
      };
    };
}
