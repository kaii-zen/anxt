locals {
  event_pattern = {
    source      = ["aws.s3"]
    detail-type = ["AWS API Call via CloudTrail"]

    detail = {
      eventSource = ["s3.amazonaws.com"]
      eventName   = ["PutObject", "CopyObject"]

      requestParameters = {
        bucketName = ["${var.s3_bucket}"]
        key        = ["${var.s3_objects}"]
      }
    }
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  name          = "${var.cloudwatch_rule_name}"
  description   = "${var.cloudwatch_rule_description}"
  event_pattern = "${jsonencode(local.event_pattern)}"
}
