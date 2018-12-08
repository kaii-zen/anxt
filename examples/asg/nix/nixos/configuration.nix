{ lib, config, ... }:

let
  # "Some fancy string" => "some-fancy-string"
  kebabify = str: with lib; concatStringsSep "-" (splitString " " (toLower str));
in {
  # Get the motd from an ssm parameter we created with Terraform
  users.motd = config.ssm-params.motd;
  networking.hostName = with config.anxt; "${kebabify family}.${kebabify class}";
}
