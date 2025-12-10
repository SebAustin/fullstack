terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Default tags disabled for AWS Academy compatibility
  # AWS Academy/Vocational Labs have restricted IAM tagging permissions
}

# Generate random suffix for unique naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

#############################################
# VPC and Security Groups
#############################################

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg-${random_id.suffix.hex}"
  description = "Security group for Udagram RDS PostgreSQL database"
  vpc_id      = data.aws_vpc.default.id

  # Allow PostgreSQL access from anywhere (for development)
  ingress {
    description = "PostgreSQL from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow PostgreSQL access from Elastic Beanstalk (will be added later)
  ingress {
    description     = "PostgreSQL from Elastic Beanstalk"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Security Group for Elastic Beanstalk
resource "aws_security_group" "eb_sg" {
  name        = "${var.project_name}-eb-sg-${random_id.suffix.hex}"
  description = "Security group for Udagram Elastic Beanstalk environment"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTP from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eb-sg"
  }
}

#############################################
# RDS PostgreSQL Database
#############################################

resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-database-${random_id.suffix.hex}"

  # Engine configuration
  engine         = "postgres"
  engine_version = var.postgres_engine_version

  # Instance configuration
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"
  storage_encrypted = true

  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  # Network configuration
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name

  # Backup configuration
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  # Snapshot configuration
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.project_name}-final-snapshot-${random_id.suffix.hex}"

  # Monitoring
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = 0

  # Auto minor version upgrade
  auto_minor_version_upgrade = true

  # Deletion protection (set to false for easy cleanup)
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-database"
  }
}

# DB Subnet Group (required for RDS)
resource "aws_db_subnet_group" "postgres" {
  name       = "${var.project_name}-db-subnet-group-${random_id.suffix.hex}"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#############################################
# S3 Bucket for Frontend Hosting
#############################################

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-frontend-${random_id.suffix.hex}"

  tags = {
    Name = "${var.project_name}-frontend"
  }
}

# Bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Disable block public access
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ACL
resource "aws_s3_bucket_acl" "frontend" {
  depends_on = [
    aws_s3_bucket_ownership_controls.frontend,
    aws_s3_bucket_public_access_block.frontend,
  ]

  bucket = aws_s3_bucket.frontend.id
  acl    = "public-read"
}

# Bucket policy for public read access
resource "aws_s3_bucket_policy" "frontend" {
  depends_on = [aws_s3_bucket_public_access_block.frontend]
  
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# CORS configuration
resource "aws_s3_bucket_cors_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag", "x-amz-meta-custom-header"]
    max_age_seconds = 3000
  }
}

# Enable versioning (optional but recommended)
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Disabled"
  }
}

#############################################
# S3 Bucket for Media Storage (Optional)
#############################################

resource "aws_s3_bucket" "media" {
  bucket = "${var.project_name}-media-${random_id.suffix.hex}"

  tags = {
    Name = "${var.project_name}-media"
  }
}

# Bucket ownership controls for media
resource "aws_s3_bucket_ownership_controls" "media" {
  bucket = aws_s3_bucket.media.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Disable block public access for media
resource "aws_s3_bucket_public_access_block" "media" {
  bucket = aws_s3_bucket.media.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ACL for media
resource "aws_s3_bucket_acl" "media" {
  depends_on = [
    aws_s3_bucket_ownership_controls.media,
    aws_s3_bucket_public_access_block.media,
  ]

  bucket = aws_s3_bucket.media.id
  acl    = "public-read"
}

# Bucket policy for media
resource "aws_s3_bucket_policy" "media" {
  depends_on = [aws_s3_bucket_public_access_block.media]
  
  bucket = aws_s3_bucket.media.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.media.arn}/*"
      }
    ]
  })
}

# CORS configuration for media
resource "aws_s3_bucket_cors_configuration" "media" {
  bucket = aws_s3_bucket.media.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

#############################################
# IAM User for Deployment
#############################################

resource "aws_iam_user" "deployer" {
  count = var.create_iam_user ? 1 : 0
  
  name = "${var.project_name}-deployer"
  path = "/"

  # Tags removed for AWS Academy compatibility
  # AWS Academy/Vocational Labs don't allow IAM tagging
}

# Create access key for the user
resource "aws_iam_access_key" "deployer" {
  count = var.create_iam_user ? 1 : 0
  
  user = aws_iam_user.deployer[0].name
}

# Attach S3 Full Access policy
resource "aws_iam_user_policy_attachment" "deployer_s3" {
  count = var.create_iam_user ? 1 : 0
  
  user       = aws_iam_user.deployer[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach Elastic Beanstalk policies
resource "aws_iam_user_policy_attachment" "deployer_eb_admin" {
  count = var.create_iam_user ? 1 : 0
  
  user       = aws_iam_user.deployer[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}

resource "aws_iam_user_policy_attachment" "deployer_eb_web" {
  count = var.create_iam_user ? 1 : 0
  
  user       = aws_iam_user.deployer[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_user_policy_attachment" "deployer_eb_worker" {
  count = var.create_iam_user ? 1 : 0
  
  user       = aws_iam_user.deployer[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_user_policy_attachment" "deployer_eb_docker" {
  count = var.create_iam_user ? 1 : 0
  
  user       = aws_iam_user.deployer[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

#############################################
# IAM Role and Instance Profile for EB
#############################################

resource "aws_iam_role" "eb_ec2_role" {
  count = var.create_iam_resources ? 1 : 0

  name = "${var.project_name}-eb-ec2-role-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  # Tags removed for AWS Academy compatibility
}

# Attach policies to EB EC2 role
resource "aws_iam_role_policy_attachment" "eb_ec2_web_tier" {
  count = var.create_iam_resources ? 1 : 0

  role       = aws_iam_role.eb_ec2_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_ec2_worker_tier" {
  count = var.create_iam_resources ? 1 : 0

  role       = aws_iam_role.eb_ec2_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "eb_ec2_multicontainer_docker" {
  count = var.create_iam_resources ? 1 : 0

  role       = aws_iam_role.eb_ec2_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

# Attach S3 access for media uploads
resource "aws_iam_role_policy_attachment" "eb_ec2_s3" {
  count = var.create_iam_resources ? 1 : 0

  role       = aws_iam_role.eb_ec2_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create instance profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  count = var.create_iam_resources ? 1 : 0

  name = "${var.project_name}-eb-ec2-profile-${random_id.suffix.hex}"
  role = aws_iam_role.eb_ec2_role[0].name

  # Tags removed for AWS Academy compatibility
}

#############################################
# Generate JWT Secret
#############################################

resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}

