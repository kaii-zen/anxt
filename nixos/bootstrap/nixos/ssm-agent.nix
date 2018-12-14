{ lib, pkgs, config, ... }:
{
  services.ssm-agent.enable = true;

  systemd.services.ssm-agent = {
    path                  = with pkgs; [ bash git gnutar gzip config.system.build.nixos-rebuild ];
    environment.NIX_PATH  = builtins.concatStringsSep ":" config.nix.nixPath;
    serviceConfig.Restart = lib.mkForce "always";
  };
}
