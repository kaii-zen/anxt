{ lib, pkgs, config, ... }:
{
  # That's all the config we need to enable SSM to rebuild the system
  services.ssm-agent.enable = true;
  imports = [ ./ec2-tags.nix ./ssm-params.nix ];
  systemd.services.ssm-agent = {
    path = with pkgs; [ bash git gnutar config.system.build.nixos-rebuild ];
    environment.NIX_PATH = builtins.concatStringsSep ":" config.nix.nixPath;
    serviceConfig.Restart = lib.mkForce "always";
  };
}
