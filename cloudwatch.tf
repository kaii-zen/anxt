# Nix expressions are provided as s3 objects
module "watch_s3_objects" {
  source = "./cloudwatch-s3-objects"

  cloudwatch_rule_name        = "${local.name_CamelCase}-${local.pet_CamelCase}-S3ChannelUpdated"
  cloudwatch_rule_description = "Run `nixos-rebuild switch` on all instances tagged `ssm-path:${local.ssm_path}` whenever ${local.bootstrap_nix_key} or ${local.user_nix_key} change"

  s3_bucket = "${var.s3_bucket}"

  s3_objects = ["${local.s3_watch_keys}"]

  run_command_document_arn  = "${local.nixos_rebuild_switch_arn}"
  run_command_target_key    = "ssm-path"
  run_command_target_values = ["${local.ssm_path}"]
}

# Settings are provided as ssm parameters
module "watch_ssm_parameters" {
  source = "./cloudwatch-ssm-params"

  cloudwatch_rule_name        = "${local.name_CamelCase}-${local.pet_CamelCase}-SSMParameterChanged"
  cloudwatch_rule_description = "Run `nixos-rebuild switch` on all instances with tagged `ssm-path:${local.ssm_path}` whenever SSM parameters change"

  run_command_document_arn  = "${local.nixos_rebuild_switch_arn}"
  run_command_document_name = "${local.nixos_rebuild_switch_name}"
  run_command_target_key    = "ssm-path"
  run_command_target_values = ["${local.ssm_path}"]

  ssm_path = "${local.ssm_path}"
}

# Whenever eitehr changes we must rebuild the system

