variable "cloudwatch_rule_name" {
  type        = "string"
  description = "Arbitrary name for the cloudwatch rule we'll create. Must be unique to the account."
}

variable "cloudwatch_rule_description" {
  type    = "string"
  default = "Invoke an SSM Run Command Document in response to updating objects in S3"
}

variable "s3_bucket" {
  type        = "string"
  description = "The bucket in which we are going to monitor objects."
}

variable "s3_objects" {
  type        = "list"
  description = "A list of objects to monitor within the given S3 bucket."
}

variable "run_command_document_arn" {
  type = "string"
}

variable "run_command_target_key" {
  type = "string"
}

variable "run_command_target_values" {
  type = "list"
}
