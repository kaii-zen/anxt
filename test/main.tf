variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs for the autoscaling group"
}

variable "security_groups" {
  type        = "list"
  description = "Security group IDs for the austoscaling group"
}

variable "cloudtrail_s3_bucket" {
  type        = "string"
  description = "Name of an S3 bucket to use with cloudtrail. We must setup a cloudtrail for cloudwatch to be able to intercept individual S3 PUT events. Please refer to AWS documentation for the correct permissions."
}

variable "s3_bucket" {
  type        = "string"
  description = "This is the S3 bucket in which we are going to store the currently active nix expression."
}

variable "s3_prefix" {
  type        = "string"
  default     = "asg"
  description = "The prefix under which Nix expressions and other configuration-specific state data will be stored. i.e., for the default value 'asg', expressions will be saved under asg/<config-id>/nixos/nixexprs.tar.xz"
}

module "this" {
  source               = "../"
  display_name         = "SSM NixOS Test"
  nixos_release        = "18.03"
  cloudtrail_s3_bucket = "${var.cloudtrail_s3_bucket}"
  s3_bucket            = "${var.s3_bucket}"
  s3_prefix            = "${var.s3_prefix}"
  nixexprs             = "${path.module}/nixos"
}

resource "aws_launch_configuration" "this" {
  name                 = "${module.this.name}"
  image_id             = "${module.this.image_id}"
  iam_instance_profile = "${module.this.iam_instance_profile}"
  user_data            = "${module.this.userdata}"
  security_groups      = ["${var.security_groups}"]
  instance_type        = "t2.micro"
  spot_price           = "1.00"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                 = "${module.this.name}"
  launch_configuration = "${aws_launch_configuration.this.name}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  min_size             = 0
  max_size             = 1
  desired_capacity     = 1

  tags = ["${module.this.tags}"]

  lifecycle {
    create_before_destroy = true
  }
}
