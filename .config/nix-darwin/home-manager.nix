{
  pkgs,
  lib,
  user,
  ...
}:
rec {

  home.stateVersion = "25.05";
  home.homeDirectory = "/Users/${user}";

  home.packages = [
    pkgs.kitty

    pkgs.tinymist # typst lsp
    pkgs.typst
    pkgs.typstyle

    pkgs.yaml-language-server
    pkgs.basedpyright
    pkgs.prettier
    pkgs.vscode-langservers-extracted # vscode-css-language-server vscode-eslint-language-server vscode-html-language-server vscode-json-language-server vscode-markdown-language-server
    pkgs.docker-compose-language-service # docker-compose-langserver
    pkgs.dockerfile-language-server # docker-langserver
    pkgs.typescript-language-server
    # see service note in configuration.nix
    pkgs.yabai
    pkgs.skhd

    pkgs.jdk
    pkgs.maven
  ];

  home.activation = {
    reloadYabaiService = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      YABAI_BIN=${pkgs.yabai}/bin/yabai
      echo "Managing yabai service..."

      # Uninstall first to prevent the "already installed" abort error
      if [ -f "$HOME/Library/LaunchAgents/com.asmvik.yabai.plist" ]; then
        $YABAI_BIN --uninstall-service
      fi

      $YABAI_BIN --install-service
      $YABAI_BIN --start-service
      echo "yabai service reinstalled and restarted"
    '';

    reloadSkhdService = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      SKHD_BIN=${pkgs.skhd}/bin/skhd
      echo "Managing skhd service..."

      # Uninstall first to prevent the "already installed" abort error
      if [ -f "$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist" ]; then
        $SKHD_BIN --uninstall-service
      fi

      $SKHD_BIN --install-service
      $SKHD_BIN --start-service
      echo "skhd service reinstalled and restarted"
    '';
  };
  launchd.agents = {
    "ke.bou.dark-mode-notify" = {
      enable = true;
      config = {
        Label = "ke.bou.dark-mode-notify";
        KeepAlive = true;
        StandardErrorPath = "/tmp/dark-mode-notify_${user}.err.log";
        StandardOutPath = "/tmp/dark-mode-notify_${user}.out.log";
        ProgramArguments = [
          "${pkgs.dark-mode-notify}/bin/dark-mode-notify"
          "${pkgs.zsh}/bin/zsh"
          "${home.homeDirectory}/.config/dark-mode-notify/change-background.sh"
        ];
      };
    };
  };

  home.file = {
    ".config/btop/themes".source = "${pkgs.btop}/share/btop/themes";

    # ".config/nix-darwin/test-sym.nix".source =
    #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/home-manager.nix";
  };
}
