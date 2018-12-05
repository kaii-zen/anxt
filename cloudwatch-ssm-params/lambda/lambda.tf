variable "function_name" {
  type = "string"
}

variable "prefix" {
  type = "string"
}

variable "document_name" {
  type = "string"
}

variable "source_arn" {
  type = "string"
}

locals {
  tmp           = "/tmp"
  function_name = "${var.function_name}"

  params = {
    prefix       = "${var.prefix}"
    DocumentName = "${var.document_name}"
  }

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole",
  ]
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${local.tmp}/lambda.zip"

  source {
    content  = "${file("${path.module}/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${jsonencode(local.params)}"
    filename = "params.json"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = "${length(local.policy_arns)}"
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${local.policy_arns[count.index]}"
}

resource "aws_lambda_function" "this" {
  filename         = "${local.tmp}/lambda.zip"
  source_code_hash = "${data.archive_file.this.output_base64sha256}"
  function_name    = "${local.function_name}"
  role             = "${aws_iam_role.this.arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  publish          = "true"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.this.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${var.source_arn}"
}

output "arn" {
  value = "${aws_lambda_function.this.arn}"
}
