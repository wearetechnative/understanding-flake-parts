{ lib, config, ... }:

{
  options.config.example1.cron.enable = lib.mkEnable "enable cron in example";

  config = lib.mkIf config.example1.cron.enable {
    services.cron.enable = true;
  };
}
