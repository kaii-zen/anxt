module "monitor_channels" {
  source               = "./cloudtrail-s3-keys"
  cloudtrail_name      = "${local.name_CamelCase}-${local.pet_CamelCase}-MonitorChannels"
  cloudtrail_s3_bucket = "${var.cloudtrail_s3_bucket}"
  s3_bucket            = "${var.s3_bucket}"
  s3_keys              = ["${local.s3_prefix}/nixos/"]
}
