resource "aws_iam_role" "aft_provisioner_codepipeline" {
  name               = "aft-provisioner-codepipeline-role"
  assume_role_policy = templatefile("${path.module}/templates/trust-policies/codepipeline.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_provisioner_codepipeline" {
  name = "aft-provisioner-cloudpipeline-policy"
  role = aws_iam_role.aft_provisioner_codepipeline.id

  policy = templatefile("${path.module}/templates/role-policies/aft_provisioner_codepipeline_policy.tpl", {
    aws_s3_bucket_aft_provisioner_bucket_arn    = aws_s3_bucket.aft_provisioner.arn
    data_aws_region_current_name                = data.aws_region.current.name
    data_aws_caller_identity_current_account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "aft_provisioner_codebuild" {
  name               = "aft-provisioner-codebuild-role"
  assume_role_policy = templatefile("${path.module}/templates/trust-policies/codebuild.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_provisioner_codebuild" {
  name = "aft-provisioner-codebuild-policy"
  role = aws_iam_role.aft_provisioner_codebuild.id

  policy = templatefile("${path.module}/templates/role-policies/aft_provisioner_codebuild_policy.tpl", {
    aws_s3_bucket_aft_provisioner_bucket_arn    = aws_s3_bucket.aft_provisioner.arn
    data_aws_region_current_name                = data.aws_region.current.name
    data_aws_caller_identity_current_account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "aft_provisioner_admin" {
  name               = "AWSAFTAdmin"
  assume_role_policy = templatefile("${path.module}/templates/trust-policies/admin.tpl", { trusted_role = aws_iam_role.aft_provisioner_codebuild.arn })
}

resource "aws_iam_role_policy_attachment" "administrator_access_attachment" {
  role       = aws_iam_role.aft_provisioner_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
