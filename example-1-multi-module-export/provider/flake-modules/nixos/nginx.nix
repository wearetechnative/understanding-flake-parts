{ lib, config, ... }:

{
  options.config.example1.nginx.enable = lib.mkEnable "enable nginx in example";

  config = lib.mkIf config.example1.nginx.enable {
    services.nginx.enable = true;
  };
}
