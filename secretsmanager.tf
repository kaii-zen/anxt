resource "aws_ssm_parameter" "secretsmanager_path" {
  name  = "${local.ssm_path}/secretsmanager-path"
  type  = "String"
  value = "${local.secretsmanager_path}"
}
