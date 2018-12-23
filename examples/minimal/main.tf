module "codebuild" {
  source              = "../../"
  name                = "example"
  artifact_bucket_arn = "${aws_s3_bucket.artifact.arn}"
}

resource "aws_s3_bucket" "artifact" {
  bucket        = "artifact-codebuild-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true
}

data "aws_caller_identity" "current" {}
