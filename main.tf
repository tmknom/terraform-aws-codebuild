# Terraform module which creates CodeBuild resources on AWS.
#
# https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html

# https://www.terraform.io/docs/providers/aws/r/codebuild_project.html
resource "aws_codebuild_project" "default" {
  name         = var.name
  description  = var.description
  service_role = aws_iam_role.default.arn

  # Information about the build output artifacts for the build project.
  # https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectArtifacts.html
  artifacts {
    type = "CODEPIPELINE"
  }

  # Information about the build environment of the build project.
  # https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectEnvironment.html
  environment {
    # The type of build environment to use for related builds.
    # Available values are: LINUX_CONTAINER or WINDOWS_CONTAINER.
    type = var.environment_type

    # Information about the compute resources the build project uses. Available values include:
    #
    # - BUILD_GENERAL1_SMALL: Use up to 3 GB memory and 2 vCPUs for builds.
    # - BUILD_GENERAL1_MEDIUM: Use up to 7 GB memory and 4 vCPUs for builds.
    # - BUILD_GENERAL1_LARGE: Use up to 15 GB memory and 8 vCPUs for builds.
    #
    # BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER
    compute_type = var.compute_type

    # The image identifier of the Docker image to use for this build project.
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image = var.image

    # Enables running the Docker daemon inside a Docker container.
    # Set to true only if the build project is be used to build Docker images,
    # and the specified build environment image is not provided by AWS CodeBuild with Docker support.
    # Otherwise, all associated builds that attempt to interact with the Docker daemon fail.
    privileged_mode = var.privileged_mode
  }

  # Information about the build input source code for the build project.
  # https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectSource.html
  source {
    type = "CODEPIPELINE"

    # The build spec declaration to use for this build project's related builds.
    # If you include a build spec as part of the source code, by default,
    # the build spec file must be named buildspec.yml and placed in the root of your source directory.
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec-ref-name-storage
    buildspec = var.buildspec
  }

  # Information about the cache for the build project.
  # https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectCache.html
  cache {
    # The type of cache used by the build project. Valid values include:
    #
    # - NO_CACHE: The build project does not use any cache.
    # - S3: The build project reads and writes from and to S3.
    type = var.cache_type

    # Information about the cache location:
    #
    # - NO_CACHE: This value is ignored.
    # - S3: This is the S3 bucket name/prefix.
    location = var.cache_location
  }

  # The KMS customer master key (CMK) to be used for encrypting the build output artifacts.
  # You can specify either the Amazon Resource Name (ARN) of the CMK or,
  # if available, the CMK's alias (using the format alias/alias-name ).
  #
  # If set empty string, CodeBuild uses the AWS-managed CMK for Amazon S3 in your AWS account.
  # https://docs.aws.amazon.com/codebuild/latest/userguide/setting-up.html#setting-up-kms
  encryption_key = var.encryption_key

  # How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out
  # any related build that does not get marked as completed.
  build_timeout = var.build_timeout

  # A mapping of tags to assign to the resource.
  tags = merge({ "Name" = var.name }, var.tags)
}

# CodeBuild Service Role
#
# https://docs.aws.amazon.com/codebuild/latest/userguide/setting-up.html#setting-up-service-role

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "default" {
  name               = local.iam_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  path               = var.iam_path
  description        = var.description
  tags               = merge({ "Name" = local.iam_name }, var.tags)
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
  name        = local.iam_name
  policy      = data.aws_iam_policy_document.policy.json
  path        = var.iam_path
  description = var.description
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
      local.log_group_arn,
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
      var.artifact_bucket_arn,
      "${var.artifact_bucket_arn}/*",
    ]
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

# ECR provides several managed policies that you can attach to IAM users or EC2 instances
# that allow differing levels of control over Amazon ECR resources and API operations.
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/ecr_managed_policies.html
resource "aws_iam_role_policy_attachment" "ecr" {
  count = var.enabled_ecr_access

  role       = aws_iam_role.default.name
  policy_arn = var.ecr_access_policy_arn
}

locals {
  iam_name      = "${var.name}-codebuild"
  log_group_arn = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${var.name}"

  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
