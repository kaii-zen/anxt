{ stubs
, helpers
, newScope }:

let
  callModule = module: overrides: (newScope self) module ({ inherit helpers; } // stubs // overrides);
  self = rec {
    mkAutoScalingGroup = callModule ./autoscaling.nix {};
    mkInstance         = callModule ./instance.nix    {};
    mkS3Channel        = callModule ./s3-channel.nix  {};
    mkPlumbing         = callModule ./plumbing.nix    {};
  };
in self
