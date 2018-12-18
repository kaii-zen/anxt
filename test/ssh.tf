resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Type less...
locals {
  private_key = "${tls_private_key.this.private_key_pem}"
  public_key  = "${tls_private_key.this.public_key_openssh}"
}

# Pass public key through SSM parameter store
resource "aws_ssm_parameter" "this_pubkey" {
  name  = "${module.this.ssm_path}/public_key"
  type  = "String"
  value = "${local.public_key}!"
}

resource "aws_key_pair" "this" {
  public_key = "${local.public_key}"
}

output "ssh" {
  value = "ssh -i id_rsa root@${aws_instance.this.public_ip}"
}
