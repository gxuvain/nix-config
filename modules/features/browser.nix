{ inputs, ... }:
{
  flake.modules.darwin.browser = {
    homebrew.casks = [ "zen" ];
  };

  # Linux only: on macOS Zen comes from the Homebrew cask above.
  flake.modules.homeManager.browser = {
    imports = [ inputs.zen-browser.homeModules.beta ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
