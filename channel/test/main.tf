module "test" {
  source           = "../"
  name             = "test"
  nixexprs         = "${path.root}/nixos"
  binary-cache-url = "http://cache.lies.org"
}

locals {
  tests     = "${file("${path.module}/test.sh")}"
  tests_md5 = "${md5(local.tests)}"
}

resource "null_resource" "test" {
  triggers {
    path  = "${module.test.path}"
    tests = "${local.tests_md5}"
  }

  provisioner "local-exec" {
    command = "${path.module}/test.sh"

    environment {
      out_path = "${self.triggers.path}"
    }
  }
}
