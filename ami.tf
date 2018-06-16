module "ami" {
  source  = "github.com/terraform-community-modules/tf_aws_nixos_ami"
  release = "${var.nixos_release}"
}
