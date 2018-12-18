# Pass private key through Secrets Manager
resource "aws_secretsmanager_secret" "this" {
  # We must place the secret under the path provided by the ANXT module.
  # This will then be found in /var/run/private_key;
  # test.sh will verify that it's been actually put there (currently there's no verification of the content)
  name = "${module.this.secretsmanager_path}/private_key"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = "${aws_secretsmanager_secret.this.id}"
  secret_string = "${local.private_key}"
}
