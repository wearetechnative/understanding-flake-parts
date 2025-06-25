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
      {
        imports = [
          inputs.devshell.flakeModule
        ];

        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

        perSystem = _: {
          devshells.default = { };

          checks.services-nixos-module = withSystem "x86_64-linux" (

            { config, pkgs, ... }:

            pkgs.testers.runNixOSTest {

              name = "services-nixos-module";
              nodes.machine1 = { config, pkgs, ... }: {
                imports = [
                  inputs.provider.flakeModules.default
                  #                  inputs.provider.flakeModules.cron
                  #                  inputs.provider.flakeModules.nginx
                  #                  inputs.provider.flakeModules.hello
                  #                  inputs.provider.flakeModules.more-apps
                ];
                example1.cron.enable = true;
                example1.nginx.enable = true;
                example1.hello.enable = true;
                example1.more-apps.enable = true;
              };

              # This is Python calling a testing api
              testScript = ''
                _, output = machine.systemctl("status cron")
                assert "cron" in output
                _, output = machine.systemctl("status nginx")
                assert "nginx" in output

                machine.succeed("hello")
                machine.succeed("fortune")
              '';
            }
          );

        };

      }
    );
}
