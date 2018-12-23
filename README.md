# terraform-aws-codebuild

[![CircleCI](https://circleci.com/gh/tmknom/terraform-aws-codebuild.svg?style=svg)](https://circleci.com/gh/tmknom/terraform-aws-codebuild)
[![GitHub tag](https://img.shields.io/github/tag/tmknom/terraform-aws-codebuild.svg)](https://registry.terraform.io/modules/tmknom/codebuild/aws)
[![License](https://img.shields.io/github/license/tmknom/terraform-aws-codebuild.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module template following [Standard Module Structure](https://www.terraform.io/docs/modules/create.html#standard-module-structure).

## Usage

Named `terraform-<PROVIDER>-<NAME>`. Module repositories must use this three-part name format.

```sh
curl -fsSL https://raw.githubusercontent.com/tmknom/terraform-aws-codebuild/master/install | sh -s terraform-aws-sample
cd terraform-aws-sample && make install
```

## Examples

- [Minimal](https://github.com/tmknom/terraform-aws-codebuild/tree/master/examples/minimal)
- [Complete](https://github.com/tmknom/terraform-aws-codebuild/tree/master/examples/complete)

## Inputs

| Name                | Description                                                                                           |  Type  |              Default              | Required |
| ------------------- | ----------------------------------------------------------------------------------------------------- | :----: | :-------------------------------: | :------: |
| artifact_bucket_arn | The S3 Bucket ARN of artifacts.                                                                       | string |                 -                 |   yes    |
| name                | The projects name.                                                                                    | string |                 -                 |   yes    |
| build_timeout       | How long in minutes to wait until timing out any related build that does not get marked as completed. | string |               `60`                |    no    |
| buildspec           | The build spec declaration to use for this build project's related builds.                            | string |              `` | no              |
| cache_location      | The location where the AWS CodeBuild project stores cached resources.                                 | string |              `` | no              |
| cache_type          | The type of storage that will be used for the AWS CodeBuild project cache.                            | string |            `NO_CACHE`             |    no    |
| compute_type        | Information about the compute resources the build project will use.                                   | string |      `BUILD_GENERAL1_SMALL`       |    no    |
| description         | The description of the all resources.                                                                 | string |      `Managed by Terraform`       |    no    |
| encryption_key      | The KMS CMK to be used for encrypting the build project's build output artifacts.                     | string |              `` | no              |
| environment_type    | The type of build environment to use for related builds.                                              | string |         `LINUX_CONTAINER`         |    no    |
| iam_path            | Path in which to create the IAM Role and the IAM Policy.                                              | string |                `/`                |    no    |
| image               | The image identifier of the Docker image to use for this build project.                               | string | `aws/codebuild/ubuntu-base:14.04` |    no    |
| privileged_mode     | If set to true, enables running the Docker daemon inside a Docker container.                          | string |              `false`              |    no    |
| tags                | A mapping of tags to assign to all resources.                                                         |  map   |               `{}`                |    no    |

## Outputs

| Name                   | Description                                                                                                     |
| ---------------------- | --------------------------------------------------------------------------------------------------------------- |
| codebuild_project_arn  | The ARN of the CodeBuild project.                                                                               |
| codebuild_project_id   | The name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project. |
| iam_policy_arn         | The ARN assigned by AWS to this IAM Policy.                                                                     |
| iam_policy_description | The description of the IAM Policy.                                                                              |
| iam_policy_document    | The policy document of the IAM Policy.                                                                          |
| iam_policy_id          | The IAM Policy's ID.                                                                                            |
| iam_policy_name        | The name of the IAM Policy.                                                                                     |
| iam_policy_path        | The path of the IAM Policy.                                                                                     |
| iam_role_arn           | The Amazon Resource Name (ARN) specifying the IAM Role.                                                         |
| iam_role_create_date   | The creation date of the IAM Role.                                                                              |
| iam_role_description   | The description of the IAM Role.                                                                                |
| iam_role_name          | The name of the IAM Role.                                                                                       |
| iam_role_unique_id     | The stable and unique string identifying the IAM Role.                                                          |

## Development

### Requirements

- [Docker](https://www.docker.com/)

### Configure environment variables

```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=ap-northeast-1
```

### Installation

```shell
git clone git@github.com:tmknom/terraform-aws-codebuild.git
cd terraform-aws-codebuild
make install
```

### Makefile targets

```text
check-format                   Check format code
cibuild                        Execute CI build
clean                          Clean .terraform
docs                           Generate docs
format                         Format code
help                           Show help
install                        Install requirements
lint                           Lint code
release                        Release GitHub and Terraform Module Registry
terraform-apply-complete       Run terraform apply examples/complete
terraform-apply-minimal        Run terraform apply examples/minimal
terraform-destroy-complete     Run terraform destroy examples/complete
terraform-destroy-minimal      Run terraform destroy examples/minimal
terraform-plan-complete        Run terraform plan examples/complete
terraform-plan-minimal         Run terraform plan examples/minimal
upgrade                        Upgrade makefile
```

### Releasing new versions

Bump VERSION file, and run `make release`.

### Terraform Module Registry

- <https://registry.terraform.io/modules/tmknom/codebuild/aws>

## License

Apache 2 Licensed. See LICENSE for full details.
