resource "aws_ssm_parameter" "bucket_db_name" {
  name  = "/staging/bucket/db"
  type  = "String"
  value = aws_s3_bucket.sqlite_db.bucket
}

resource "aws_ssm_parameter" "access_key" {
  name  = "/staging/s3-user/access-key"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.id
}

resource "aws_ssm_parameter" "access_secret" {
  name  = "/staging/s3-user/access-secret"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.secret
}

