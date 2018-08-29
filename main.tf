module "label" {
  source             = "git::https://github.com/halberom/terraform-null-label.git?ref=handle_default"
  additional_tag_map = "${var.additional_tag_map}"
  attributes         = "${var.attributes}"
  context            = "${var.context}"
  delimiter          = "${var.delimiter}"
  environment        = "${var.environment}"
  label_order        = "${var.label_order}"
  name               = "${var.name}"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  tags               = "${var.tags}"
}

module "s3_bucket_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.5.0"
  attributes = ["state"]
  context    = "${module.label.context}"
}

resource "aws_s3_bucket" "default" {
  bucket        = "${module.s3_bucket_label.id}"
  acl           = "${var.acl}"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${module.s3_bucket_label.tags}"
}

module "dynamodb_table_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.5.0"
  attributes = ["lock"]
  context    = "${module.label.context}"
}

resource "aws_dynamodb_table" "with_server_side_encryption" {
  count          = "${var.enable_server_side_encryption == "true" ? 1 : 0}"
  name           = "${module.dynamodb_table_label.id}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "LockID"                                                 # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${module.dynamodb_table_label.tags}"
}

resource "aws_dynamodb_table" "without_server_side_encryption" {
  count          = "${var.enable_server_side_encryption == "true" ? 0 : 1}"
  name           = "${module.dynamodb_table_label.id}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "LockID"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${module.dynamodb_table_label.tags}"
}
