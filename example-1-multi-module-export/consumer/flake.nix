{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";

    provider.url = "github:wearetechnative/understanding-flake-parts/?dir=example-1-multi-module-export/provider";
  };

  outputs =
    inputs@{ flake-parts, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, moduleWithSystem, flake-parts-lib, ... }:
      #let
      #inherit (flake-parts-lib) importApply;
      #foo-flake-mod = importApply ./flake-modules/foo { inherit withSystem moduleWithSystem importApply; };
      #in
      {
        imports = [
          inputs.devshell.flakeModule
        ];

        #imports = [ foo-flake-mod ];

        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

        perSystem = _: {
          devshells.default = { };

          checks.foo-nixos-module = withSystem "x86_64-linux" (

            { config, pkgs, ... }:

            pkgs.testers.runNixOSTest {

              name = "nginx-nixos-module";
              nodes.machine1 = { config, pkgs, ... }: {
                imports = [
                  inputs.provider.flakeModules.cron
                ];
              };

              testScript = ''
                _, output = machine.systemctl("status cron")
                assert "Hello, world" in output
              '';
            }
          );

        };

      }
    );
}
