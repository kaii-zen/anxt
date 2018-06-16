# This is supposed to be copied to (actual) /etc/nixos/user.nix
# by the first SSM agent run, prior to updating channels and
# and running nixos-rebuild. This essentially allows the bootstrap
# run to run on its own before we load the user's configuration.
# That is to work around an issue where the initial environemnt doesn't
# have git or tar installed and therefore cannot use any of the
# builtins.fetch* commands; which the user might want to use
# in their config.
{
  imports = [ <user/configuration.nix> ];
}
