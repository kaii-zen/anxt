{ pkgs, lib, config, ... }:

let
  # "Some fancy string" => "some-fancy-string"
  kebabify = str: with lib; concatStringsSep "-" (splitString " " (toLower str));
in {
  # Get the motd from an ssm parameter we created with Terraform
  users.motd = config.ssm-params.motd;
  networking.hostName = with config.anxt; "${kebabify family}.${kebabify class}";
  environment.systemPackages = with pkgs; [
    awscli
    jq
    vim
  ];

  users.users.test-user = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [ config.ssm-params.public_key ];
  };

  security.sudo.wheelNeedsPassword = false;
}
