data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ssm_lifecycle_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_lifecycle" {
  statement {
    effect  = "Allow"
    actions = ["ssm:SendCommand"]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${var.run_command_target_key}"
      values   = ["${var.run_command_target_values}"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = ["${var.run_command_document_arn}"]
  }
}

resource "aws_iam_role" "ssm_lifecycle" {
  name               = "${format("%.64s", "${aws_cloudwatch_event_rule.this.name}-CloudwatchRole")}"
  description        = "Allow Cloudwatch to invoke ${var.run_command_document_arn} on instances with ${var.run_command_target_key}:[${join(",", var.run_command_target_values)}]"
  assume_role_policy = "${data.aws_iam_policy_document.ssm_lifecycle_trust.json}"
}

resource "aws_iam_policy" "ssm_lifecycle" {
  name   = "${aws_cloudwatch_event_rule.this.name}-Allow"
  policy = "${data.aws_iam_policy_document.ssm_lifecycle.json}"
}

resource "aws_iam_role_policy_attachment" "ssm_lifecycle" {
  role       = "${aws_iam_role.ssm_lifecycle.name}"
  policy_arn = "${aws_iam_policy.ssm_lifecycle.arn}"
}

resource "aws_cloudwatch_event_target" "this" {
  arn      = "${var.run_command_document_arn}"
  role_arn = "${aws_iam_role.ssm_lifecycle.arn}"

  rule = "${aws_cloudwatch_event_rule.this.name}"

  run_command_targets {
    key    = "tag:${var.run_command_target_key}"
    values = ["${var.run_command_target_values}"]
  }
}
