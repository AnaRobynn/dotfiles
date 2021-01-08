{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.editors.emacs;
in {
  options.modules.editors.emacs = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };

    doom = {
      enable = mkOption {
        type = bool;
        default = true;
      };
    } ;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ 
      (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
    ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
    environment.systemPackages = with pkgs; [
      ## Emacs itself
      binutils       # native-comp needs 'as', provided by this
      emacsPgtkGcc   # 28 + pgtk + native-comp

      ## Doom dependencies
      git
      (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      fd                  # faster projectile indexing
      imagemagick         # for image-dired
      zstd                # for undo-fu-session/undo-tree compression
      fd
      clang

      ## Module dependencies
      # checkers
      (aspellWithDicts (ds: with ds; [
        en en-computers en-science
      ]))
      languagetool
      # org-mode
      sqlite
      texlive.combined.scheme-medium
      # c programming
      ccls
      editorconfig-core-c 
      # javascript
      nodePackages.javascript-typescript-langserver
      # rust
      rustfmt
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    modules.shell.zsh.rcFiles = [ "/etc/nixos/config/emacs/aliases.zsh" ];
    
    home-manager.users.venikx = mkIf cfg.doom.enable {
      xdg.configFile."doom".source = "/etc/nixos/config/doom";
    };
    home-manager.users.root = mkIf cfg.doom.enable {
      xdg.configFile."doom".source = "/etc/nixos/config/doom";
    };
  };
}