module "test_user_channel" {
  source   = "../channel"
  name     = "test_user"
  nixexprs = "${path.module}/channel"
}

locals {
  test_user_channel_key = "channels/${module.test_user_channel.name}.tar.xz"
}

resource "aws_s3_bucket_object" "test_user_channel" {
  bucket = "${var.s3_bucket}"
  key    = "${var.s3_prefix}/${local.test_user_channel_key}"
  source = "${module.test_user_channel.path}"
  etag   = "${md5(file(module.test_user_channel.path))}"
}
