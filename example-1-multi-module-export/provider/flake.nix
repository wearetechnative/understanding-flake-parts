{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, moduleWithSystem, flake-parts-lib, ... }:

      {
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
        imports = [
          inputs.devshell.flakeModule
        ];

        flake.flakeModules.default = {
          imports = [
            ./flake-modules/nixos/cron.nix
            ./flake-modules/nixos/nginx.nix
            ./flake-modules/nixos/hello.nix
            ./flake-modules/nixos/more-apps.nix
          ];
        };

        flake.flakeModules.cron = { pkgs, ... }: {
          imports = [ ./flake-modules/nixos/cron.nix ];
        };

        flake.flakeModules.nginx = ./flake-modules/nixos/nginx.nix;
        flake.flakeModules.hello = ./flake-modules/nixos/hello.nix;
        flake.flakeModules.more-apps = ./flake-modules/nixos/more-apps.nix;

        perSystem = _: {
          devshells.default = { };
        };
      }
    );
}
