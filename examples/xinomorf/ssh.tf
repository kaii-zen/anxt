resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Type less...
locals {
  private_key = "${tls_private_key.this.private_key_pem}"
  public_key  = "${tls_private_key.this.public_key_openssh}"
}

resource "aws_key_pair" "this" {
  public_key = "${local.public_key}"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "install -m 600 /dev/null id_rsa && echo \"$SSH_KEY\" > id_rsa"

    environment {
      SSH_KEY = "${local.private_key}"
    }
  }
}

output "info" {
  value = "You may use `./id_rsa` to connect to the instance. It is up to you to figure out its IP address since it's an ASG. Good luck; and don't fuck it up."
}
