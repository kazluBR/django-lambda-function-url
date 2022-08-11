resource "aws_ssm_parameter" "access_key" {
  name  = "/prod/s3-user/access-key"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.id
}

resource "aws_ssm_parameter" "access_secret" {
  name  = "/prod/s3-user/access-secret"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.secret
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/prod/database/endpoint"
  type  = "SecureString"
  value = aws_db_instance.database.address
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/prod/database/name"
  type  = "SecureString"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/prod/database/user"
  type  = "SecureString"
  value = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/prod/database/password"
  type  = "SecureString"
  value = random_string.db_password.result
}
