{ lib, config, pkgs, ... }:

{
  options.example1.more-apps.enable = lib.mkEnableOption "enable more apps in example";

  config = lib.mkIf config.example1.more-apps.enable {
    environment.systemPackages = with pkgs; [
      cowsay
      fortune
    ];

  };
}

