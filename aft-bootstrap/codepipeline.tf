
# Pipeline

resource "aws_codepipeline" "aft_provisioner" {
  name     = "aft-provisioner"
  role_arn = aws_iam_role.aft_provisioner_codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.aft_provisioner.bucket
    type     = "S3"
  }

  ##############################################################
  # Source
  ##############################################################
  stage {
    name = "Source"

    action {
      name             = "aft-provisioner"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["aft-provisioner-source"]

      configuration = {
        RepositoryName       = "aft-provisioner"
        BranchName           = "main"
        PollForSourceChanges = false
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  ##############################################################
  # Apply AFT provisoning
  ##############################################################
  stage {
    name = "terraform-apply"

    action {
      name             = "Apply-Terraform"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["aft-provisioner-source"]
      output_artifacts = ["aft-provisioner-terraform"]
      version          = "1"
      run_order        = "2"
      configuration = {
        ProjectName = aws_codebuild_project.aft_provisioner.name
      }
    }
  }
}


