module "lambda" {
  source        = "./lambda"
  function_name = "${var.cloudwatch_rule_name}"
  prefix        = "${var.ssm_path}"
  document_name = "${var.run_command_document_name}"
  source_arn    = "${aws_cloudwatch_event_rule.this.arn}"
}

resource "aws_cloudwatch_event_target" "that" {
  arn  = "${module.lambda.arn}"
  rule = "${aws_cloudwatch_event_rule.this.name}"
}
