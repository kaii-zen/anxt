{ config, ... }:

{
  # Get the motd from an ssm parameter we created with Terraform
  users.motd = config.ssm-params.motd;
}
