variable "name" {
  description = "Document name"
  type        = "string"
}

variable "type" {
  description = "SSM Document type; must be `Command`, `Policy` or `Automation`"
  type        = "string"
}

variable "content" {
  description = "Content of the SSM Document as a Terraform map (rather than JSON. whole purpose of this module is my hatred towrads JSON <<HEREDOCS)"
  type        = "map"
}

resource "aws_ssm_document" "this" {
  name          = "${var.name}"
  document_type = "${var.type}"
  content       = "${jsonencode(var.content)}"
}

output "name" {
  value = "${aws_ssm_document.this.name}"
}

output "arn" {
  value = "${aws_ssm_document.this.arn}"
}
