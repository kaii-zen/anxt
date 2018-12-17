{ pkgs, mkPlumbing
, resource, module, ... }:

{ displayName, nixosConfig, keyName, s3Bucket, s3Prefix, securityGroups, subnetId
, instanceType    ? "t2.micro"
, nixosRelease    ? "18.09"
, rootSize        ? 50
, spotPrice       ? 1.00
, minSize         ? 1
, maxSize         ? 1
, desiredCapacity ? 1 }:

assert builtins.isString s3Bucket;
assert builtins.isString s3Prefix;
assert builtins.isString subnetId;
assert builtins.isList securityGroups && securityGroups != [];
assert spotPrice != null -> builtins.isFloat spotPrice;

let
  inherit (pkgs) lib runCommand;
  inherit (lib) optionalAttrs;

  anxt = mkPlumbing { inherit displayName nixosRelease s3Bucket s3Prefix nixosConfig; };

  instance = let
    wantSpot     = spotPrice != null;
    resourceType = if wantSpot then "aws_spot_instance_request" else "aws_instance";
    spotAttrs    = optionalAttrs wantSpot {
      spotPrice = toString spotPrice;
    };

  in
  resource resourceType anxt.name (spotAttrs // {
    inherit instanceType keyName subnetId;
    inherit (anxt) ami iamInstanceProfile userData;
    tags                          = anxt.tagsMap;
    vpcSecurityGroupIds           = securityGroups;
    rootBlockDevice.volumeSize    = toString rootSize;
    rootBlockDevice.volumeType    = "gp2";
    lifecycle.createBeforeDestroy = true;
    dependsOn                     = [ anxt.module ];
  }) [];

in [ anxt instance ]
