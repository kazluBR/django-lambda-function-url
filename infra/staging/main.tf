provider "aws" {
  region = var.region

  default_tags {
    tags = {
      service = "django-lambda"
      STAGE   = "staging"
    }
  }
}

resource "aws_s3_bucket" "sqlite_db" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "sqlite_db_access" {
  bucket                  = aws_s3_bucket.sqlite_db.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "sqlite_db_access_ownership" {
  bucket = aws_s3_bucket.sqlite_db.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_iam_user" "s3_user" {
  name = "s3-user"
}

resource "aws_iam_access_key" "s3_user_access_key" {
  user = aws_iam_user.s3_user.name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
}

resource "aws_iam_user_policy" "s3_user_policy" {
  name   = "sqlite-s3-policy"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.s3_policy.json
}
