data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
resource "random_pet" "this" {}

locals {
  name_kebab           = "${replace(var.display_name, " ", "-")}"
  name_kebab_lowercase = "${lower(local.name_kebab)}"
  name_CamelCase       = "${replace(title(var.display_name), " ", "")}"
  name                 = "${local.name_kebab_lowercase}-${local.pet}"
  name_prefix          = "${local.name}-"
  prefix               = "${var.prefix}"

  pet           = "${random_pet.this.id}"
  pet_title     = "${title(replace(local.pet, "-", " "))}"
  pet_CamelCase = "${replace(local.pet_title, " ", "")}"

  secretsmanager_path = "${local.prefix}/${local.name_kebab_lowercase}/${local.pet}"
  ssm_path            = "/${local.prefix}/${local.name_kebab_lowercase}/${local.pet}"
  ssm_path_arn        = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path}/*"

  nixos_rebuild_switch_arn  = "${aws_ssm_document.nixos_rebuild_switch.arn}"
  nixos_rebuild_switch_name = "${aws_ssm_document.nixos_rebuild_switch.name}"

  bootstrap_nix_key = "${aws_s3_bucket_object.bootstrap_nix.key}"
  user_nix_key      = "${aws_s3_bucket_object.user_nix.key}"
  s3_watch_keys     = "${concat(list(local.bootstrap_nix_key, local.user_nix_key), formatlist("${local.prefix}/%s", values(var.extra_s3_channels)))}"
  s3_prefix         = "${local.prefix}/${local.name}"

  primary_channels = {
    nixos     = "http://nixos.org/channels/nixos-${var.nixos_release}"
    bootstrap = "s3://${var.s3_bucket}/${local.bootstrap_nix_key}"
    user      = "s3://${var.s3_bucket}/${local.user_nix_key}"
  }

  s3_channels = "${zipmap(keys(var.extra_s3_channels), formatlist("s3://${var.s3_bucket}/${var.prefix}/%s", values(var.extra_s3_channels)))}"

  channels = "${merge(local.primary_channels, local.s3_channels)}"
}
