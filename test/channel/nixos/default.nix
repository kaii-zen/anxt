{ config, ... }:
{
  users.users.test-user = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [ config.ssm-params.public_key ];
  };
}
