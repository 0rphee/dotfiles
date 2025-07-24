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
    pkgs.pyright # pyright & pyright-lang-server - NOTE: check basedpyright
    pkgs.nodePackages.prettier
    pkgs.vscode-langservers-extracted # vscode-css-language-server vscode-eslint-language-server vscode-html-language-server vscode-json-language-server vscode-markdown-language-server
    pkgs.docker-compose-language-service # docker-compose-langserver
    pkgs.dockerfile-language-server-nodejs # docker-langserver
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
      echo yabai bin: $YABAI_BIN
      run $YABAI_BIN --uninstall-service
      run $YABAI_BIN --install-service
      run $YABAI_BIN --start-service
      echo "yabai service reinstalled and restarted"
    '';
    reloadSkhdService = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      SKHD_BIN=${pkgs.skhd}/bin/skhd
      echo skhd bin: $SKHD_BIN
      run $SKHD_BIN --uninstall-service
      run $SKHD_BIN --install-service
      run $SKHD_BIN --start-service
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
