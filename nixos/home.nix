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
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    glow
    neofetch
    p7zip
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = let
    dotfilesDir = "${config.home.homeDirectory}/.config/dotfiles";
  in {
    ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/kitty.conf";
    ".config/ranger/rc.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ranger/rc.conf";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/addison/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "eza --color=auto";
        lx = "eza -lhAXF --group-directories-first";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = "set --global --export SHELL (command -v fish)";
    };

    fzf.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    btop.enable = true;

    starship = {
      enable = true;
      enableTransience = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Addison Hernandez";
      userEmail = "addison.hernandez@gmail.com";
      aliases = {
        co = "checkout";
        ci = "commit";
        civ = "commit --verbose";
        st = "status";
        br = "branch";
        logadog = "log --all --decorate --oneline --graph";
        freeze = "update-index --skip-worktree";
      };
      ignores = [
        "*~"
        ".*.swp"
        ".DS_Store"
      ];
      delta = {
        enable = true;
        options = {
          navigate = "true";
          # syntax-theme = "gruvbox-dark";
          features = "catppuccin-macchiato";
        };
      };
      extraConfig = {
        include = {
          path = "$HOME/.themes/delta/catppuccin.gitconfig";
        };
        init = {
          defaultBranch = "main";
        };
        help = {
          autocorrect = "50";
        };
        merge = {
          conflictStyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
        fetch = {
          prune = "true";
        };
        commit = {
          verbose = "true";
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
