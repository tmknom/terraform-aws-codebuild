variable "name" {
  type        = "string"
  description = "The projects name."
}

variable "artifact_bucket_arn" {
  type        = "string"
  description = "The S3 Bucket ARN of artifacts."
}

variable "iam_path" {
  default     = "/"
  type        = "string"
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = "string"
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = "map"
  description = "A mapping of tags to assign to all resources."
}
