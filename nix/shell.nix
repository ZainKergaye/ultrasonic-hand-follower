{ forEachSupportedSystem }:
forEachSupportedSystem (
  { pkgs
  , system
  , self
  ,
  }:
  {
    default = pkgs.mkShell {
      packages = with pkgs; [
        git
        fastfetch
        onefetch
      ];

    };
  }
)
