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

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/database/endpoint"
  type  = "SecureString"
  value = aws_db_instance.database.address
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/database/name"
  type  = "SecureString"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/database/user"
  type  = "SecureString"
  value = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/database/password"
  type  = "SecureString"
  value = random_string.db_password.result
}

resource "aws_ssm_parameter" "subnet_id" {
  name  = "/vpc/public-subnets"
  type  = "StringList"
  value = join(",", module.vpc.public_subnets)
}

resource "aws_ssm_parameter" "security_group_id" {
  name  = "/vpc/security-group-id"
  type  = "String"
  value = aws_security_group.main.id
}
