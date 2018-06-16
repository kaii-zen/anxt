module "ec2-iam-role" {
  source     = "github.com/Smartbrood/terraform-aws-ec2-iam-role"
  name       = "${local.name}"
  policy_arn = "${local.policy_arns}"
}
