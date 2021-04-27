{ config, pkgs, lib, ... }:

let
  userData = {
    name = "Henry de Valence";
    email = "hdevalence@hdevalence.ca";
  };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {

  home.sessionVariables = {
    EDITOR = "code --wait";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    MOZ_ENABLE_WAYLAND = "1";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib";
  };

  # fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    let
      unfreePkgs = [
        slack
        unstable.discord
        signal-desktop
        # zoom-us
        # steam
        # keybase
        # keybase-gui
        vscode
        # nodejs-12_x # required for vscode remote ssh
        unstable._1password
        unstable._1password-gui
      ];
    in ([
      # wayland firefox
      firefox-wayland
      # firefox
      # firefox-devedition-bin
      # tor-browser-bundle-bin

      # toolchains
      rustup
      clang
      llvmPackages.bintools
      llvmPackages.libclang
      stack
      zlib.dev
      nodePackages.npm
      nodePackages.typescript
      gnumake

      # dev tools
      meld

      # rusty unix utils
      unstable.exa
      unstable.tokei
      unstable.xsv
      unstable.ripgrep
      unstable.fd
      unstable.bottom
      # unstable.broot
      # bat # installed via `programs.bat` 

      # github cli
      gitAndTools.gh

      psmisc

      # gnome
      gnome3.gnome-tweaks
      glib.dev

      # networking tools
      # nmap-graphical
      # mtr-gui
      # slurm
      bandwhich
      # assorted wiresharks
      # wireshark
      # termshark
      magic-wormhole

      # kubernetes
      # kubectl
      # unstable.kube3d
      # kubectx
      # k9s
      # stern
      # helm

      # images, etc
      # ark
      # darktable
      # unstable.inkscape
      vlc

      # stuff
      # neofetch
      # wpgtk
      # pywal
      # obs-studio

      # "crypto"
      # kbfs
      # gnupg

      # nix stuff
      nix-prefetch-git
      nixfmt

      # wally-cli

      # fonts
      iosevka
      unstable.cozette
      #   cherry
      roboto
    ] ++ unfreePkgs);

  #############################################################################
  ## Programs                                                                 #
  #############################################################################
  programs = {
    jq.enable = true;
    bat.enable = true;
    command-not-found.enable = true;

    broot = {
      enable = true;
      # enableZshIntegration = true;
      # package = unstable.broot;
      skin = {
        default = "gray(23) none";
        tree = "ansi(94) None / gray(3) None";
        file = "gray(18) None / gray(15) None";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = userData.name;
      userEmail = userData.email;
      extraConfig = {
        merge.tool = "meld";
      };
      aliases = {
        rb = "rebase";
        rbct = "rebase --continue";
        # sign the last commit
        sign = "commit --amend --reuse-message=HEAD -sS";
        uncommit = "reset --hard HEAD";
        ls = ''
          log --pretty=format:"%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn]" --decorate'';
        ll = ''
          log --pretty=format:"%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn]" --decorate --numstat'';
        lt = "log --graph --oneline --decorate --all";
        st = "status --short --branch";
        stu = "status -uno";
        co = "checkout";
        ci = "commit";
        pr =
          "!pr() { git fetch origin pull/$1/head:pr-$1; git checkout pr-$1; }; pr";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        please = "push --force-with-lease";
        commend = "commit --amend --no-edit";
        squash = "merge --squash";
        # Get the current branch name (not so useful in itself, but used in
        # other aliases)
        branch-name = "!git rev-parse --abbrev-ref HEAD";
        # Push the current branch to the remote "origin", and set it to track
        # the upstream branch
        publish = "!git push -u origin $(git branch-name)";
        # Delete the remote version of the current branch
        unpublish = "!git push origin :$(git branch-name)";
      };

    };

    htop = {
      enable = true;
      highlightBaseName = true;
      highlightThreads = true;
      # showThreadNames = true;
      # on NixOS, pretty much every path starts with /nix/store/(LONG SHA).
      # Because of that, when the whole path is shown, you need a really 
      # wide terminal window, or else the program names are not really 
      # readable. So let's turn off paths.
      showProgramPath = false;
      # This is rarely useful but it's cool to see, if you're me.
      # hideKernelThreads = false;

      # I have entirely too many cores for the default meter configuration to
      # be useable. :)
      meters = {
        left = [ "LeftCPUs2" "Blank" "Memory" "Swap" ];
        right =
          [ "RightCPUs2" "Blank" "Hostname" "Uptime" "Tasks" "LoadAverage" ];
      };
    };

    alacritty = {
      enable = true;
      settings = {
        # Configuration for Alacritty, the GPU enhanced terminal emulator
        # Live config reload (changes require restart)
        live_config_reload = true;
        shell.program = "fish";
        window = {
          dynamic_title = true;
          # Window dimensions in character columns and lines
          # (changes require restart)
          dimensions = {
            columns = 99;
            lines = 50;
          };

          # Adds this many blank pixels of padding around the window
          # Units are physical pixels; this is not DPI aware.
          # (change requires restart)
          padding = {
            x = 10;
            y = 10;
          };

          # Window decorations
          # Setting this to false will result in window without borders and title bar.
          # decorations: false
        };

        # When true, bold text is drawn using the bright variant of colors.
        draw_bold_text_with_bright_colors = true;

        # Font configuration (changes require restart)
        font = {
          # Point size of the font
          size = 11;
          # The normal (roman) font face to use.
          normal = {
            family = "Iosevka";
            style = "Regular";
          };

          bold = {
            family = "Iosevka";
            style = "Bold";
          };

          italic = {
            family = "Iosevka";
            style = "Italic";
          };
        };
      };
    };
  };

  #############################################################################
  ## Services                                                                 #
  #############################################################################
  services = {
    # gpg-agent = { enable = true; };
    # kbfs.enable = true;
    # keybase.enable = true;
    gnome-keyring.enable = true;
  };
}
