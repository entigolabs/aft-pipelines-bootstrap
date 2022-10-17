# S3 Resources

resource "aws_s3_bucket" "aft_provisioner" {
  bucket = "aft-provisioner-${data.aws_caller_identity.current.account_id}"

  tags = {
    "Name" = "aft-provisioner-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_versioning" "aft_provisioner" {
  bucket = aws_s3_bucket.aft_provisioner.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aft_provisioner" {
  bucket = aws_s3_bucket.aft_provisioner.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "aft_provisioner" {
  bucket = aws_s3_bucket.aft_provisioner.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "aft_provisioner" {
  bucket              = aws_s3_bucket.aft_provisioner.id
  block_public_acls   = true
  block_public_policy = true
}
