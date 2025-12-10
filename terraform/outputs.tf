output "summary" {
  description = "Summary of all created resources"
  sensitive   = true
  value = <<-EOT
    ╔════════════════════════════════════════════════════════════════════╗
    ║         Udagram Infrastructure Successfully Created! 🎉            ║
    ╚════════════════════════════════════════════════════════════════════╝

    📋 SAVE THESE VALUES - You'll need them for deployment!

    ═══════════════════════════════════════════════════════════════════
    🗄️  DATABASE (RDS PostgreSQL)
    ═══════════════════════════════════════════════════════════════════
    Endpoint:       ${aws_db_instance.postgres.endpoint}
    Address:        ${aws_db_instance.postgres.address}
    Port:           ${aws_db_instance.postgres.port}
    Database Name:  ${aws_db_instance.postgres.db_name}
    Username:       ${aws_db_instance.postgres.username}
    Password:       [Set in terraform.tfvars - retrieve with: terraform output db_password]

    Connection String:
    psql -h ${aws_db_instance.postgres.address} -U ${aws_db_instance.postgres.username} -d ${aws_db_instance.postgres.db_name}

    ═══════════════════════════════════════════════════════════════════
    🪣  S3 BUCKETS
    ═══════════════════════════════════════════════════════════════════
    Frontend Bucket:        ${aws_s3_bucket.frontend.bucket}
    Frontend Website URL:   ${aws_s3_bucket_website_configuration.frontend.website_endpoint}
    Frontend Website Link:  http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}
    
    Media Bucket:           ${aws_s3_bucket.media.bucket}
    Media Region:           ${aws_s3_bucket.media.region}

    ═══════════════════════════════════════════════════════════════════
    👤  IAM DEPLOYER USER
    ═══════════════════════════════════════════════════════════════════
    ${var.create_iam_user ? "Username:               ${aws_iam_user.deployer[0].name}\n    Access Key ID:          ${aws_iam_access_key.deployer[0].id}\n    Secret Access Key:      [Retrieve with: terraform output -raw iam_secret_access_key]\n    \n    ⚠️  IMPORTANT: Save the Secret Access Key now! \n    Run: terraform output -raw iam_secret_access_key" : "IAM User NOT created (AWS Academy mode)\n    \n    ℹ️  Use your AWS Academy session credentials:\n    1. Go to AWS Academy > AWS Details\n    2. Copy AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY\n    3. Use these for CircleCI and local deployments\n    \n    Note: AWS Academy credentials expire after a few hours"}

    ═══════════════════════════════════════════════════════════════════
    🔒  SECURITY
    ═══════════════════════════════════════════════════════════════════
    RDS Security Group:     ${aws_security_group.rds_sg.id}
    EB Security Group:      ${aws_security_group.eb_sg.id}
    JWT Secret:             [Retrieve with: terraform output -raw jwt_secret]

    ═══════════════════════════════════════════════════════════════════
    📝  RETRIEVE SENSITIVE VALUES
    ═══════════════════════════════════════════════════════════════════
    Get these values with these commands:

    terraform output -raw iam_access_key_id
    terraform output -raw iam_secret_access_key
    terraform output -raw jwt_secret

    ═══════════════════════════════════════════════════════════════════
    📝  ENVIRONMENT VARIABLES FOR ELASTIC BEANSTALK
    ═══════════════════════════════════════════════════════════════════
    Copy these for your EB configuration:

    POSTGRES_USERNAME=${aws_db_instance.postgres.username}
    POSTGRES_PASSWORD=[Your database password from terraform.tfvars]
    POSTGRES_HOST=${aws_db_instance.postgres.address}
    POSTGRES_DB=${aws_db_instance.postgres.db_name}
    AWS_BUCKET=${aws_s3_bucket.media.bucket}
    AWS_REGION=${var.aws_region}
    JWT_SECRET=[Use: terraform output -raw jwt_secret]
    URL=http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}

    ═══════════════════════════════════════════════════════════════════
    📝  ENVIRONMENT VARIABLES FOR CIRCLECI
    ═══════════════════════════════════════════════════════════════════
    Add these to your CircleCI project settings:

    ${var.create_iam_user ? "AWS_ACCESS_KEY_ID=[Use: terraform output -raw iam_access_key_id]\n    AWS_SECRET_ACCESS_KEY=[Use: terraform output -raw iam_secret_access_key]" : "AWS_ACCESS_KEY_ID=[From AWS Academy > AWS Details]\n    AWS_SECRET_ACCESS_KEY=[From AWS Academy > AWS Details]\n    AWS_SESSION_TOKEN=[From AWS Academy > AWS Details - if shown]"}
    AWS_REGION=${var.aws_region}
    AWS_DEFAULT_REGION=${var.aws_region}
    AWS_BUCKET=${aws_s3_bucket.frontend.bucket}
    POSTGRES_USERNAME=${aws_db_instance.postgres.username}
    POSTGRES_PASSWORD=[Your database password from terraform.tfvars]
    POSTGRES_HOST=${aws_db_instance.postgres.address}
    POSTGRES_DB=${aws_db_instance.postgres.db_name}
    JWT_SECRET=[Use: terraform output -raw jwt_secret]
    URL=http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}

    ═══════════════════════════════════════════════════════════════════
    ⏭️   NEXT STEPS
    ═══════════════════════════════════════════════════════════════════
    1. Save sensitive values:
       terraform output -raw iam_secret_access_key > secret_key.txt
       terraform output -raw jwt_secret > jwt_secret.txt
       
    2. Test database connection:
       psql -h ${aws_db_instance.postgres.address} -U ${aws_db_instance.postgres.username} -d ${aws_db_instance.postgres.db_name}

    3. Configure AWS CLI:
       aws configure
       # Use: terraform output -raw iam_access_key_id
       # Use: terraform output -raw iam_secret_access_key

    4. Update environment.prod.ts with your EB URL (after creating EB)

    5. Create Elastic Beanstalk environment:
       cd udagram/udagram-api
       eb init
       eb create --single --instance-types t2.medium

    6. Set environment variables in EB using the values above

    7. Deploy your application!

    ═══════════════════════════════════════════════════════════════════
    💡 TIPS
    ═══════════════════════════════════════════════════════════════════
    - Save all outputs in a secure password manager
    - Never commit credentials to Git
    - Keep the terraform.tfstate file secure (contains sensitive data)
    - To see this output again, run: terraform output summary
    - To get sensitive values: terraform output -raw <output_name>

    ╔════════════════════════════════════════════════════════════════════╗
    ║                     Happy Deploying! 🚀                            ║
    ╚════════════════════════════════════════════════════════════════════╝
  EOT
}

#############################################
# Individual Outputs (for programmatic access)
#############################################

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "RDS PostgreSQL address (without port)"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.postgres.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.postgres.db_name
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "s3_frontend_bucket" {
  description = "S3 bucket name for frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "s3_frontend_website_url" {
  description = "S3 frontend website URL"
  value       = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"
}

output "s3_media_bucket" {
  description = "S3 bucket name for media"
  value       = aws_s3_bucket.media.bucket
}

output "iam_user_name" {
  description = "IAM deployer username"
  value       = var.create_iam_user ? aws_iam_user.deployer[0].name : "Not created (using AWS Academy session credentials)"
}

output "iam_access_key_id" {
  description = "IAM access key ID"
  value       = var.create_iam_user ? aws_iam_access_key.deployer[0].id : "Use AWS Academy credentials"
  sensitive   = true
}

output "iam_secret_access_key" {
  description = "IAM secret access key"
  value       = var.create_iam_user ? aws_iam_access_key.deployer[0].secret : "Use AWS Academy credentials"
  sensitive   = true
}

output "jwt_secret" {
  description = "Generated JWT secret"
  value       = random_password.jwt_secret.result
  sensitive   = true
}

output "db_password" {
  description = "Database password (from terraform.tfvars)"
  value       = var.db_password
  sensitive   = true
}

output "eb_instance_profile" {
  description = "Elastic Beanstalk EC2 instance profile name"
  value       = var.create_iam_resources ? aws_iam_instance_profile.eb_ec2_profile[0].name : "Use default: aws-elasticbeanstalk-ec2-role"
}

output "eb_security_group_id" {
  description = "Elastic Beanstalk security group ID"
  value       = aws_security_group.eb_sg.id
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

