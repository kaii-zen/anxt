module "ec2-iam-role" {
  source = "github.com/Smartbrood/terraform-aws-ec2-iam-role"
  name   = "${local.name}"

  policy_arn = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
  ]
}
