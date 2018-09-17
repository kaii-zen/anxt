variable "cloudwatch_rule_name" {
  type        = "string"
  description = "Arbitrary name for the cloudwatch rule we'll create. Must be unique to the account."
}

variable "cloudwatch_rule_description" {
  type    = "string"
  default = "Invoke an SSM Run Command Document in response to updating an SSM parameter"
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
