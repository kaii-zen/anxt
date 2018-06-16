{ lib, pkgs, config, ... }:
{
  # That's all the config we need to enable SSM to rebuild the system
  services.ssm-agent.enable = true;
  systemd.services.ssm-agent = {
    path = with pkgs; [ bash git gnutar config.system.build.nixos-rebuild ];
    environment.NIX_PATH = builtins.concatStringsSep ":" config.nix.nixPath;
  };
}
