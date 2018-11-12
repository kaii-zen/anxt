{ lib, config, ... }:

with lib; {
  options.ec2-tags = mkOption {
    description = "EC2 instance tags";
    default = {};
    type = types.attrs;
  };

  config.ec2-tags = importJSON /etc/ec2-metadata/tags.json;
}
