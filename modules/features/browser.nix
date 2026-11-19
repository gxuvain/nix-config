{ inputs, ... }:
{
  flake.modules.darwin.browser = {
    homebrew.casks = [
      "zen"
      "helium-browser"
    ];
  };

  flake.modules.homeManager.browser = {
    imports = [
      inputs.zen-browser.homeModules.beta
      inputs.helium.homeModules.default
    ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };

    programs.helium.enable = true;
  };
}
