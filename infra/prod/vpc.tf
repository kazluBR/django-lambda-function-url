module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "django-lambda-vpc-${local.stage}"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = []
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "django-lambda-subnet-${local.stage}"
  subnet_ids = module.vpc.public_subnets
}

resource "aws_security_group" "main" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.public_route_table_ids
}
