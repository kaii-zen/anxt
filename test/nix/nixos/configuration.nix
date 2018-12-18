{ pkgs, lib, config, ... }:

let
  # "Some fancy string" => "some-fancy-string"
  kebabify = str: with lib; concatStringsSep "-" (splitString " " (toLower str));
in {
  networking.hostName = with config.anxt; "${kebabify family}.${kebabify class}";
  environment.systemPackages = with pkgs; [
    awscli
    jq
    vim
  ];

  security.sudo.wheelNeedsPassword = false;

  imports = [
    <users/nixos>
    ./motd.nix
  ];
}
