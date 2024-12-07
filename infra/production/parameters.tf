resource "aws_ssm_parameter" "cloudfront_url" {
  name  = "/production/cloudfront/url"
  type  = "String"
  value = aws_cloudfront_distribution.storage_files_distribution.domain_name
}

resource "aws_ssm_parameter" "access_key" {
  name  = "/production/s3-user/access-key"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.id
}

resource "aws_ssm_parameter" "access_secret" {
  name  = "/production/s3-user/access-secret"
  type  = "SecureString"
  value = aws_iam_access_key.s3_user_access_key.secret
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/production/database/endpoint"
  type  = "String"
  value = aws_db_instance.database.address
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/production/database/name"
  type  = "String"
  value = local.db_name
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/production/database/user"
  type  = "String"
  value = local.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/production/database/password"
  type  = "SecureString"
  value = random_string.db_password.result
}

resource "aws_ssm_parameter" "subnet_id" {
  name  = "/production/vpc/public-subnets"
  type  = "StringList"
  value = join(",", module.vpc.public_subnets)
}

resource "aws_ssm_parameter" "security_group_id" {
  name  = "/production/vpc/security-group-id"
  type  = "String"
  value = aws_security_group.main.id
}

resource "random_string" "django_secret_key" {
  length  = 50
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_ssm_parameter" "django_secret_key" {
  name  = "/production/django-secret-key"
  type  = "SecureString"
  value = random_string.django_secret_key.result
}

resource "random_string" "django_superuser_password" {
  length  = 8
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_ssm_parameter" "django_superuser_password" {
  name  = "/production/django/superuser-password"
  type  = "SecureString"
  value = random_string.django_superuser_password.result
}
