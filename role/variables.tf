variable "s3_policy" {
  type        = string
  description = "(Required) S3 Policy for IAM"
  default     = "{}"
}

variable "hostname_prefix" {
  type        = string
  description = "(Required) A unique name."
}

variable "iam_policy_enabled" {
  type        = bool
  description = "(Required) Enabled custom policy for IAM/S3 objects default is true"
  default     = true
}

variable "iam_role_name" {
  type        = string
  description = "(Required) Provides the ability for customers to input their own IAM role name"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "(Required) The type of the EC2 instance. Default is 'c5n.9xlarge'"
  default     = "c5n.9xlarge"
}