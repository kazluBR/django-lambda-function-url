variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type = string
}

variable "db_name" {
  default = "app"
}

variable "db_user" {
  default = "admin"
}

resource "random_string" "db_password" {
  length  = 8
  special = true
}
