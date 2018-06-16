# We create two nix "channels" here. Our channels
# are just tarballs with expressions that we upload to s3.

# One with the config necessary to get SSM up and running
# on the instance;
module "bootstrap_channel" {
  source   = "./channel"
  name     = "bootstrap"
  nixexprs = "${path.module}/nixos/bootstrap"
}

# And the other one for user-supplied expressions
module "user_channel" {
  source = "./channel"
  name   = "user"

  # if no user expressions were provided we use a stab so that bootstrapping SSM can finish
  nixexprs = "${var.nixexprs == "" ? "${path.module}/nixos/user" : "${var.nixexprs}"}"
}

resource "aws_s3_bucket_object" "bootstrap_nix" {
  bucket = "${var.s3_bucket}"
  key    = "${local.s3_prefix}/nixos/channels/${module.bootstrap_channel.name}.tar.xz"
  source = "${module.bootstrap_channel.path}"
  etag   = "${md5(file(module.bootstrap_channel.path))}"
}

resource "aws_s3_bucket_object" "user_nix" {
  bucket = "${var.s3_bucket}"
  key    = "${local.s3_prefix}/nixos/channels/${module.user_channel.name}.tar.xz"
  source = "${module.user_channel.path}"
  etag   = "${md5(file(module.user_channel.path))}"
}
