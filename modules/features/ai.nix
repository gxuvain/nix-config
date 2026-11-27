{ inputs, ... }:
{
  flake.modules.darwin.ai = {
    homebrew.casks = [ "anomalyco/tap/hex" "claude" ];
  };

  flake.modules.nixos.ai = { };

  flake.modules.homeManager.ai = { config, pkgs, ... }:
    let
      assets = "${config.home.homeDirectory}/Dev/nix-config/assets";
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      # claude-code from sadjow/claude-code-nix (tracks releases hourly).
      # Update with: nix flake update claude-code
      home.packages = with pkgs; [
        inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
        pi-coding-agent
      ];

      home.file.".pi/agent/settings.json".source =
        mkOutOfStoreSymlink "${assets}/pi/settings.json";
      home.file.".pi/agent/themes/catppuccin-mocha.json".source =
        mkOutOfStoreSymlink "${assets}/pi/themes/catppuccin-mocha.json";

      home.file.".agents/skills".source = mkOutOfStoreSymlink "${assets}/skills";
      xdg.stateFile."skills/.skill-lock.json".source =
        mkOutOfStoreSymlink "${assets}/skills-lock.json";
    };
}
