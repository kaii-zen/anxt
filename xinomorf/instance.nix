{ lib, runCommand, resource, ... }:

id:

{ keyName, securityGroups, subnetId, plumbing
, instanceType    ? "t2.micro"
, rootSize        ? 50
, spotPrice       ? 1.00 }:

assert builtins.isString subnetId;
assert builtins.isList securityGroups && securityGroups != [];
assert spotPrice != null -> builtins.isFloat spotPrice;

let
  instance = let
    wantSpot     = spotPrice != null;
    resourceType = if wantSpot then "aws_spot_instance_request" else "aws_instance";
    spotAttrs    = lib.optionalAttrs wantSpot {
      spotPrice = toString spotPrice;
    };

  in
  resource resourceType "${plumbing}_${id}" (spotAttrs // {
    inherit instanceType keyName subnetId;
    inherit (plumbing) ami iamInstanceProfile userData;
    tags                          = plumbing.tagsMap;
    vpcSecurityGroupIds           = securityGroups;
    rootBlockDevice.volumeSize    = toString rootSize;
    rootBlockDevice.volumeType    = "gp2";
    lifecycle.createBeforeDestroy = true;
    dependsOn                     = [ plumbing.module ];
  }) [];

in [ instance ]
