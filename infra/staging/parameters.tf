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

resource "random_string" "django_secret_key" {
  length  = 50
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_ssm_parameter" "django_secret_key" {
  name  = "/staging/django-secret-key"
  type  = "SecureString"
  value = random_string.django_secret_key.result
}

