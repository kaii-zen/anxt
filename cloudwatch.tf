# Nix expressions are provided as s3 objects
module "watch_s3_objects" {
  source = "./cloudwatch-s3-objects"

  cloudwatch_rule_name        = "${local.name_CamelCase}-${local.pet_CamelCase}-RebuildSystemOnChannelUpdate"
  cloudwatch_rule_description = "Run `nixos-rebuild switch` on all instances with Id:${local.id} whenever ${local.bootstrap_nix_key} or ${local.user_nix_key} change"

  s3_bucket  = "${var.s3_bucket}"
  s3_objects = ["${local.bootstrap_nix_key}", "${local.user_nix_key}"]

  run_command_document_arn  = "${module.ssm_nixos_rebuild_switch.arn}"
  run_command_target_key    = "Id"
  run_command_target_values = ["${local.id}"]
}

# Settings are provided as ssm parameters
module "watch_ssm_parameters" {
  source = "./cloudwatch-ssm-params"

  cloudwatch_rule_name        = "${local.name_CamelCase}-${local.pet_CamelCase}-RebuildSystemOnParameterChange"
  cloudwatch_rule_description = "Run `nixos-rebuild switch` on all instances with Id:${local.id} whenever SSM parameters change"

  run_command_document_arn  = "${module.ssm_nixos_rebuild_switch.arn}"
  run_command_target_key    = "Id"
  run_command_target_values = ["${local.id}"]
}

# Whenever eitehr changes we must rebuild the system

