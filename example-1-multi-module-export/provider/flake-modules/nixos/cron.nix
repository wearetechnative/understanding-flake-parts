{ lib, config, ... }:

{
  options.example1.cron.enable = lib.mkEnableOption "enable cron in example";

  config = lib.mkIf config.example1.cron.enable {
    services.cron.enable = true;
  };
}
