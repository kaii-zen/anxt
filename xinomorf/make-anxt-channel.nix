{ pkgs }:

{ resource, ... }:

{ name, s3, nixexprs }:

assert builtins.isString name && name != "";
assert s3 ? bucket && builtins.isString s3.bucket;
assert s3 ? prefix && builtins.isString s3.prefix;

let
  channel = import ../channel {
    inherit name nixexprs;
  };

in [
  (resource "aws_s3_bucket_object" "${name}_channel" {
    inherit (s3) bucket;
    key    = "${s3.prefix}/${name}.tar.xz";
    source = channel;
    etag   = ''''${md5(file("${channel}"))}'';
  } [])
]
