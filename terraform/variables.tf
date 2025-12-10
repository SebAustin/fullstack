variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "udagram"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

#############################################
# RDS Variables
#############################################

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "postgres"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"  # Free tier eligible
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20  # Free tier limit
}

variable "postgres_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "14.15"  # PostgreSQL 14.15 (verified available)
}

#############################################
# S3 Variables
#############################################

variable "enable_s3_versioning" {
  description = "Enable versioning for S3 buckets"
  type        = bool
  default     = false
}

variable "create_iam_user" {
  description = "Create IAM deployer user (set to false for AWS Academy)"
  type        = bool
  default     = false  # Disabled by default for AWS Academy compatibility
}

variable "create_iam_resources" {
  description = "Create IAM roles and instance profiles (set to false for AWS Academy)"
  type        = bool
  default     = false  # Disabled by default for AWS Academy compatibility
}

#############################################
# Tags
#############################################

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

