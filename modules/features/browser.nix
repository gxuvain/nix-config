{ inputs, ... }:
{
  flake.modules.darwin.browser = {
    homebrew.casks = [
      "helium-browser"
    ];
  };

  flake.modules.homeManager.browser = {
    imports = [
      inputs.helium.homeModules.default
    ];

    programs.helium.enable = true;
  };
}
