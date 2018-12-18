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
    command = "install -m 600 /dev/null id_rsa && echo \"$SSH_KEY\" > id_rsa"

    environment {
      SSH_KEY = "${local.private_key}"
    }
  }

  provisioner "remote-exec" {
    script = "test.sh"
  }
}
