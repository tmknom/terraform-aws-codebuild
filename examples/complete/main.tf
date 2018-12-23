module "codebuild" {
  source              = "../../"
  name                = "example"
  artifact_bucket_arn = "${aws_s3_bucket.artifact.arn}"

  environment_type = "LINUX_CONTAINER"
  compute_type     = "BUILD_GENERAL1_MEDIUM"
  image            = "aws/codebuild/docker:18.09.0"
  privileged_mode  = true
  buildspec        = "configuration/buildspec.yml"
  cache_type       = "S3"
  cache_location   = "${aws_s3_bucket.artifact.id}/codebuild"
  encryption_key   = ""
  build_timeout    = 10
  iam_path         = "/service-role/"
  description      = "This is example"

  tags = {
    Environment = "prod"
  }
}

resource "aws_s3_bucket" "artifact" {
  bucket        = "artifact-codebuild-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true
}

data "aws_caller_identity" "current" {}
