module "this" {
  source        = "../"
  display_name  = "Test"
  nixos_release = "18.09"
  s3_bucket     = "${var.s3_bucket}"
  nixexprs      = "${path.module}/nix"
}

# Create an SSM parameter to be used from the NixOS configuration. (see ./nix/nixos/configuration.nix)
resource "aws_ssm_parameter" "this_motd" {
  name  = "${module.this.ssm_path}/motd"
  type  = "String"
  value = "Hello, world!"
}

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

# Pass private key through Secrets Manager
resource "aws_secretsmanager_secret" "this" {
  name                    = "${module.this.secretsmanager_path}/private_key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = "${aws_secretsmanager_secret.this.id}"
  secret_string = "${local.private_key}"
}

resource "aws_key_pair" "this" {
  public_key = "${local.public_key}"
}

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

resource "null_resource" "this" {
  triggers {
    instance_id = "${aws_instance.this.id}"
    script      = "${md5(file("test.sh"))}"
  }

  connection {
    type        = "ssh"
    user        = "test-user"
    host        = "${aws_instance.this.public_ip}"
    private_key = "${local.private_key}"
  }

  provisioner "local-exec" {
    command = "echo \"$SSH_KEY\" > id_rsa"

    environment {
      SSH_KEY = "${local.private_key}"
    }
  }

  provisioner "remote-exec" {
    script = "test.sh"
  }
}

output "ssh" {
  value = "ssh -i id_rsa root@${aws_instance.this.public_ip}"
}
