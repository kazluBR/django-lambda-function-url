resource "aws_ssm_parameter" "access_key" {
  name  = "/s3-user/access-key"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.id
}

resource "aws_ssm_parameter" "access_secret" {
  name  = "/s3-user/access-secret"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.secret
}

