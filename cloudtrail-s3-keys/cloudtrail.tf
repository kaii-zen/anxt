variable "cloudtrail_name" {
  type        = "string"
  description = ""
}

variable "cloudtrail_s3_bucket" {
  type = "string"
}

variable "s3_bucket" {
  type = "string"
}

variable "s3_keys" {
  type = "list"
}

data "aws_s3_bucket" "this" {
  bucket = "${var.s3_bucket}"
}

resource "aws_cloudtrail" "this" {
  name           = "${var.cloudtrail_name}"
  s3_bucket_name = "${var.cloudtrail_s3_bucket}"

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false

    data_resource {
      type = "AWS::S3::Object"

      #values = ["${data.aws_s3_bucket.this.arn}/${var.key}"]
      values = ["${formatlist("${data.aws_s3_bucket.this.arn}/%s", var.s3_keys)}"]
    }
  }
}
