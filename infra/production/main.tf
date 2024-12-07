locals {
  region       = "us-east-1"
  service_name = "django-lambda"
  stage        = "production"
  bucket_name  = "django-lambda-bucket-storage"
  db_name      = "app"
  db_user      = "admin"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      service = local.service_name
      STAGE   = local.stage
    }
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "storage_files" {
  bucket = "${local.bucket_name}-${local.stage}-${random_string.suffix.result}"
}

resource "aws_s3_bucket_policy" "storage_files_policy" {
  bucket = aws_s3_bucket.storage_files.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.storage_files_oai.id}"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.storage_files.id}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "storage_files_distribution" {
  origin {
    domain_name = aws_s3_bucket.storage_files.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.storage_files.id}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.storage_files_oai.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for S3 storage"
  default_root_object = ""

  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.storage_files.id}"

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "storage_files_oai" {
  comment = "OAI for accessing S3 storage files"
}

resource "aws_iam_user" "s3_user" {
  name = "s3-user-${local.stage}"
}

resource "aws_iam_access_key" "s3_user_access_key" {
  user = aws_iam_user.s3_user.name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:GetObjectAcl", "s3:PutObjectAcl", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.storage_files.id}", "arn:aws:s3:::${aws_s3_bucket.storage_files.id}/*"]
  }
}

resource "aws_iam_user_policy" "s3_user_policy" {
  name   = "storage-s3-policy"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "random_string" "db_password" {
  length  = 12
  special = false
}

resource "aws_db_instance" "database" {
  identifier             = "django-lambda-database"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  db_name                = local.db_name
  username               = local.db_user
  password               = random_string.db_password.result
  parameter_group_name   = "default.mysql8.0"
  multi_az               = false
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.main.id]
}
