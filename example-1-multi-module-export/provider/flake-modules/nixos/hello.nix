{ lib, config, pkgs, ... }:

{
  options.example1.hello.enable = lib.mkEnableOption "enable hello app in example";

  config = lib.mkIf config.example1.hello.enable {
    environment.systemPackages = with pkgs; [
      hello
    ];

  };
}
