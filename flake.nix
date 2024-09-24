{
  description = "Shotcut video editor built from local source";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        localShotcut = pkgs.shotcut.overrideAttrs (oldAttrs: {
          # Override the version if needed
          version = "24.04.28"; # Update this as needed

          # Use local source instead of fetchFromGitHub
          src = ./.;

          # Remove the updateScript as it's not applicable for local builds
          passthru = (oldAttrs.passthru or {}) // {
            updateScript = null;
          };

          # You can add or modify other attributes as needed
          # For example, if you need to add or change build inputs:
          # buildInputs = oldAttrs.buildInputs ++ [ pkgs.someNewDependency ];
        });

      in
      {
        packages = {
          default = localShotcut;
          shotcut = localShotcut;
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
        };
      }
    );
}
