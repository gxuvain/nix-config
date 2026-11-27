{ inputs, ... }:
{
  flake.modules.homeManager.desktop-shell = { lib, pkgs, ... }: {
    imports = [ inputs.dms.homeModules.dank-material-shell ];

    config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.dank-material-shell = {
        enable = true;
        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        settings = {
          fontFamily = "FantasqueSansM Nerd Font";
          monoFontFamily = "FantasqueSansM Nerd Font";

          barConfigs = [
            {
              attachToScreenEdge = false;
              autoHide = false;
              autoHideDelay = 250;
              autoHideStrict = false;
              barInsetPadding = -1;
              barLengthMode = "full";
              barLengthPadding = 0;
              barLengthPercent = 80;
              batteryColorMode = "theme";
              borderColor = "surfaceText";
              borderEnabled = false;
              borderOpacity = 1;
              borderThickness = 1;
              bottomGap = 0;
              centerWidgets = [
                "music"
                "clock"
                "weather"
              ];
              clickActionFollowMouse = false;
              clickThrough = false;
              dot = false;
              enabled = true;
              followInterfaceStyle = true;
              fontScale = 1;
              gothCornerRadiusOverride = false;
              gothCornerRadiusValue = 12;
              gothCornersEnabled = false;
              hideOnFullscreen = false;
              hoverPopoutDelay = 150;
              hoverPopouts = false;
              iconScale = 1;
              id = "default";
              innerPadding = 2;
              leftWidgets = [
                "launcherButton"
                "workspaceSwitcher"
                "focusedWindow"
              ];
              maximizeDetection = true;
              maximizeWidgetIcons = false;
              maximizeWidgetText = false;
              middleClickAction = "none";
              name = "Main Bar";
              noBackground = false;
              openOnOverview = false;
              popupGapsAuto = true;
              popupGapsManual = 4;
              position = 0;
              rightClickAction = "none";
              rightWidgets = [
                "systemTray"
                "clipboard"
                "cpuUsage"
                "memUsage"
                "notificationButton"
                "battery"
                "controlCenterButton"
              ];
              screenPreferences = [ "all" ];
              scrollEnabled = true;
              scrollXBehavior = "focusWindow";
              scrollYBehavior = "workspace";
              shadowColorMode = "default";
              shadowCustomColor = "#000000";
              shadowDirection = "top";
              shadowDirectionMode = "inherit";
              shadowIntensity = 0;
              shadowOpacity = 60;
              showOnLastDisplay = true;
              showOnWindowsOpen = false;
              spacing = 4;
              squareCorners = false;
              surfaceColor = "default";
              surfaceCustomColor = "#6750A4";
              transparency = 1;
              useOverlayLayer = false;
              visible = true;
              widgetFollowInterfaceStyle = true;
              widgetOutlineColor = "primary";
              widgetOutlineEnabled = false;
              widgetOutlineOpacity = 1;
              widgetOutlineThickness = 1;
              widgetPadding = 8;
              widgetStyle = "pills";
              widgetTransparency = 1;
            }
          ];
          builtInPluginSettings = {
            dms_clipboard_search = {
              trigger = "cb";
            };
            dms_power = {
              trigger = "pw";
            };
            dms_qr_generator = {
              trigger = "qrg";
            };
            dms_settings_search = {
              trigger = "?";
            };
          };
          configVersion = 42;
          connectedFrameBarStyleBackups = {
            default = {
              attachToScreenEdge = false;
              borderEnabled = false;
              gothCornersEnabled = false;
              shadowIntensity = 0;
              squareCorners = false;
            };
          };
          currentThemeCategory = "dynamic";
          currentThemeName = "dynamic";
          density = "comfortable";
          dmsWindowsFloatingSeeded = [ "niri" ];
          frameEnabled = true;
          matugenSpec = "2021";

          weatherEnabled = true;
          useAutoLocation = true;
        };
      };
    };
  };
}
