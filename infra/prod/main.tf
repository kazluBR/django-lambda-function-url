provider "aws" {
  region = var.region

  default_tags {
    tags = {
      service = "django-lambda"
      STAGE   = "prod"
    }
  }
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_user" "s3_user" {
  name = "s3-user-terraform"
}

resource "aws_iam_access_key" "s3_user_access_key" {
  user = aws_iam_user.s3_user.name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:GetObjectAcl", "s3:PutObjectAcl", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
  }
}

resource "aws_iam_user_policy" "s3_user_policy" {
  name   = "storage-s3-policy"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_db_instance" "database" {
  identifier             = "django-lambda-database"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = var.db_name
  username               = var.db_user
  password               = random_string.db_password.result
  parameter_group_name   = "default.mysql5.7"
  multi_az               = false
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
}
