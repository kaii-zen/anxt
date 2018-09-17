{ lib, config, ... }:

with lib; {
  options.ssm-params = mkOption {
    description = "SSM parameters";
    default = {};
    type = types.attrs;
  };

  config.ssm-params = importJSON /etc/ec2-metadata/ssm-params.json;
}
