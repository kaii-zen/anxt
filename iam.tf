data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_read_own_ssm_params" {
  statement {
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path}/*",
    ]
  }
}

resource "aws_iam_policy" "allow_read_own_ssm_params" {
  policy = "${data.aws_iam_policy_document.allow_read_own_ssm_params.json}"
}

data "aws_iam_policy_document" "allow_list_secrets" {
  statement {
    actions = [
      "secretsmanager:List*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "allow_list_secrets" {
  policy = "${data.aws_iam_policy_document.allow_list_secrets.json}"
}

data "aws_iam_policy_document" "allow_read_own_secrets" {
  statement {
    actions = [
      "secretsmanager:Get*",
    ]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.secrets_path}/*",
    ]
  }
}

resource "aws_iam_policy" "allow_read_own_secrets" {
  policy = "${data.aws_iam_policy_document.allow_read_own_secrets.json}"
}

locals {
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "${aws_iam_policy.allow_read_own_ssm_params.arn}",
    "${aws_iam_policy.allow_list_secrets.arn}",
    "${aws_iam_policy.allow_read_own_secrets.arn}",
  ]

  # Terraform still won't count computed values... -_-
  policy_arns_count = 6
}

resource "aws_iam_instance_profile" "this" {
  role = "${aws_iam_role.this.name}"
}

resource "aws_iam_role" "this" {
  #name               = "${local.name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = "${local.policy_arns_count}"
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${local.policy_arns[count.index]}"
}
