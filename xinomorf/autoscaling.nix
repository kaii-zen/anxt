{ lib, resource, ... }:

id:
{ keyName, securityGroups, subnetIds, plumbing
, instanceType    ? "t2.micro"
, rootSize        ? 50
, spotPrice       ? 1.00
, minSize         ? 1
, maxSize         ? 1
, desiredCapacity ? 1 }:

assert builtins.isList securityGroups && securityGroups != [];
assert builtins.isList subnetIds && subnetIds != [];
assert spotPrice != null -> builtins.isFloat spotPrice;

let
  launchConfiguration =
  resource "aws_launch_configuration" "${plumbing.name}_${id}" (
    lib.optionalAttrs (spotPrice != null) {
      spotPrice = toString spotPrice;
    } // {
    inherit instanceType keyName securityGroups;
    inherit (plumbing) namePrefix imageId iamInstanceProfile userData;

    rootBlockDevice.volumeSize = toString rootSize;
    rootBlockDevice.volumeType = "gp2";
    lifecycle.createBeforeDestroy = true;
  }) [];

  autoscalingGroup =
  resource "aws_autoscaling_group" "${plumbing.name}_${id}" {
    inherit minSize maxSize desiredCapacity;
    inherit (plumbing) tags;
    vpcZoneIdentifier   = subnetIds;
    dependsOn           = [ plumbing.module ];
    name                = "\${aws_launch_configuration.${launchConfiguration.name}.name}";
    launchConfiguration = "\${aws_launch_configuration.${launchConfiguration.name}.name}";
  } [];

in [ launchConfiguration autoscalingGroup ]
