{
  pkgs,
  config,
  lib,
  ...
}:
{

  home.stateVersion = "25.05";
  home.homeDirectory = "/Users/roger";

  home.packages = [
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

  home.file = {
    # ".config/nix-darwin/test-sym.nix".source =
    #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/home-manager.nix";
  };
}
