resource "aws_launch_configuration" "this" {
  name_prefix          = "${module.this.name_prefix}"
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
  depends_on           = ["module.this"]
  name                 = "${module.this.name}"
  launch_configuration = "${aws_launch_configuration.this.name}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  min_size             = "${var.count}"
  max_size             = "${var.count}"
  desired_capacity     = "${var.count}"

  tags = ["${module.this.tags}"]
}
