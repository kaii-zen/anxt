resource "aws_instance" "this" {
  ami                    = "${module.this.image_id}"
  instance_type          = "t2.micro"
  iam_instance_profile   = "${module.this.iam_instance_profile}"
  user_data              = "${module.this.userdata}"
  vpc_security_group_ids = ["${var.security_groups}"]
  subnet_id              = "${var.subnet_ids[0]}"
  key_name               = "${aws_key_pair.this.key_name}"

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  tags = "${module.this.tags_map}"
}
