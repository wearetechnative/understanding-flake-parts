{ lib, config, ... }:

{
  options.example1.nginx.enable = lib.mkEnableOption "enable nginx in example";

  config = lib.mkIf config.example1.nginx.enable {
    services.nginx.enable = true;
  };
}
