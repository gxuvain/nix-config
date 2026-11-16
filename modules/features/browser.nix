{ inputs, ... }:
{
  flake.modules.darwin.browser = {
    homebrew.casks = [ "zen" ];
  };

  flake.modules.homeManager.browser = {
    imports = [ inputs.zen-browser.homeModules.beta ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
