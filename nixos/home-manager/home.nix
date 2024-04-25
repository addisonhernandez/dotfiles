{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "addison";
  home.homeDirectory = "/home/addison";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    glow
    neofetch
    p7zip
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = let
    dotfilesDir = "${config.home.homeDirectory}/.config/dotfiles";
    themeDir = "${config.home.homeDirectory}/.themes/Catppuccin-Macchiato-Standard-Mauve-Dark/gtk-4.0";
  in {
    ".config/kitty/kitty.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/kitty.conf";
    ".config/ranger/rc.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ranger/rc.conf";

    # Use gtk theme with GTK 4 apps
    ".config/gtk-4.0/assets".source =
      config.lib.file.mkOutOfStoreSymlink "${themeDir}/assets";
    ".config/gtk-4.0/gtk.css".source =
      config.lib.file.mkOutOfStoreSymlink "${themeDir}/gtk.css";
    ".config/gtk-4.0/gtk-dark.css".source =
      config.lib.file.mkOutOfStoreSymlink "${themeDir}/gtk-dark.css";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs = {
    atuin = import ./configs/atuin.nix;
    bash = import ./configs/bash.nix;
    chromium = import ./configs/chromium.nix;
    direnv = import ./configs/direnv.nix;
    fish = import ./configs/fish.nix;
    git = import ./configs/git.nix;
    neovim = import ./configs/neovim.nix;
    starship = import ./configs/starship.nix;

    fzf.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    btop.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
