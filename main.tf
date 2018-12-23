# Terraform module which creates CodeBuild resources on AWS.
#
# https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html

# CodeBuild Service Role
#
# https://docs.aws.amazon.com/codebuild/latest/userguide/setting-up.html#setting-up-service-role

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "default" {
  name               = "${local.iam_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  path               = "${var.iam_path}"
  description        = "${var.description}"
  tags               = "${merge(map("Name", local.iam_name), var.tags)}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "default" {
  name        = "${local.iam_name}"
  policy      = "${data.aws_iam_policy_document.policy.json}"
  path        = "${var.iam_path}"
  description = "${var.description}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${local.log_group_arn}",
      "${local.log_group_arn}:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "${var.artifact_bucket_arn}",
      "${var.artifact_bucket_arn}/*",
    ]
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

locals {
  iam_name      = "${var.name}-codebuild"
  log_group_arn = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${var.name}"

  region     = "${data.aws_region.current.name}"
  account_id = "${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
