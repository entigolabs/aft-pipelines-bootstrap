data "local_file" "aft_provisioner_buildspec" {
  filename = "${path.module}/templates/aft-provisioner-buildspec.yml"
}

resource "aws_codebuild_project" "aft_provisioner" {
  name          = "aft-provisioner"
  description   = "Job to apply Terraform for AFT provisioning"
  build_timeout = "120"
  service_role  = aws_iam_role.aft_provisioner_codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AFT_REPOSITORY"
      value = aws_codecommit_repository.aft_provisioner.clone_url_http
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.aft_provisioner.name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.aft_provisioner.bucket}/aft-provisioner-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.aft_provisioner_buildspec.content
  }
}

resource "aws_cloudwatch_log_group" "aft_provisioner" {
  name              = "/aws/codebuild/aft-provisioner"
  retention_in_days = 365
}

