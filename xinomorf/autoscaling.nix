{ pkgs, mkPlumbing
, resource, ... }:

{ displayName, nixosConfig, keyName, s3Bucket, s3Prefix, securityGroups, subnetIds
, instanceType    ? "t2.micro"
, nixosRelease    ? "18.09"
, rootSize        ? 50
, spotPrice       ? 1.00
, minSize         ? 1
, maxSize         ? 1
, desiredCapacity ? 1 }:

assert builtins.isString s3Bucket;
assert builtins.isString s3Prefix;
assert builtins.isList securityGroups && securityGroups != [];
assert builtins.isList subnetIds && subnetIds != [];
assert spotPrice != null -> builtins.isFloat spotPrice;

let
  inherit (pkgs) lib runCommand;
  inherit (lib) optionalAttrs;

  anxt = mkPlumbing { inherit displayName nixosRelease s3Bucket s3Prefix nixosConfig; };

  launchConfiguration =
  resource "aws_launch_configuration" "${anxt.name}_lc" (
    optionalAttrs (spotPrice != null) {
      spotPrice = toString spotPrice;
    } // {
    inherit instanceType keyName securityGroups;
    inherit (anxt) namePrefix imageId iamInstanceProfile userData;

    rootBlockDevice.volumeSize = toString rootSize;
    rootBlockDevice.volumeType = "gp2";
    lifecycle.createBeforeDestroy = true;
  }) [];

  autoscalingGroup =
  resource "aws_autoscaling_group" "${anxt.name}_asg" {
    inherit minSize maxSize desiredCapacity;
    inherit (anxt) tags;
    vpcZoneIdentifier   = subnetIds;
    dependsOn           = [ anxt.module ];
    name                = "\${aws_launch_configuration.${launchConfiguration.name}.name}";
    launchConfiguration = "\${aws_launch_configuration.${launchConfiguration.name}.name}";
  } [];

in [ anxt launchConfiguration autoscalingGroup ]
