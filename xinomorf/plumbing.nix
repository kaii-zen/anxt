{ lib, runCommand
, module, ... }:

{ displayName, nixosConfig, s3Bucket, s3Prefix
, nixosRelease ? "18.09" }:

assert builtins.isString s3Bucket;
assert builtins.isString s3Prefix;

let
  nixexprs = runCommand "exprs" {} ''
    mkdir -p $out
    cd $out
    echo '{}' > default.nix
    cp -r ${nixosConfig} nixos
  '';

  fixName      = name: builtins.replaceStrings [ " " "/" "\\"] [ "_" "-" "-" ] (lib.toLower name);
  resourceName = fixName displayName;

  anxt =
  module resourceName {
    source        = "${../.}";
    inherit nixexprs displayName nixosRelease s3Bucket;
  };
in anxt // rec {
  module             = "module.${resourceName}";
  namePrefix         = "\${${module}.name_prefix}";
  imageId            = "\${${module}.image_id}";
  ami                = imageId;
  iamInstanceProfile = "\${${module}.iam_instance_profile}";
  userData           = "\${${module}.userdata}";
  tags               = ["\${${module}.tags}"];
  tagsMap            = "\${${module}.tags_map}";
}
