module "codebuild" {
  source = "../../"
  name   = "example"
}

resource "aws_s3_bucket" "artifact" {
  bucket        = "artifact-codebuild-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true
}

data "aws_caller_identity" "current" {}
