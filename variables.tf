variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "environment" {
  description = "the environment of the stack (E.g. dev)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`, `infra`)"
}

variable "name" {
  type        = "string"
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "additional_tag_map" {
  type        = "map"
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "context" {
  type        = "map"
  default     = {}
  description = "Default context to use for passing state between label invocations"
}

variable "label_order" {
  type        = "list"
  default     = ["attribute", "name", "stage", "environment", "namespace"]
  description = "The naming order of the id output and Name tag"
}

variable "region" {
  type        = "string"
  description = "AWS Region the S3 bucket should reside in"
}

variable "acl" {
  type        = "string"
  description = "The canned ACL to apply to the S3 bucket"
  default     = "private"
}

variable "read_capacity" {
  default     = 5
  description = "DynamoDB read capacity units"
}

variable "write_capacity" {
  default     = 5
  description = "DynamoDB write capacity units"
}

variable "force_destroy" {
  description = "A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable"
  default     = "false"
}

variable "enable_server_side_encryption" {
  description = "Enable DynamoDB server-side encryption"
  default     = "true"
}
