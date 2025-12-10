# Terraform Infrastructure for Udagram

This Terraform configuration automatically creates all the AWS resources needed for the Udagram application deployment.

## 🎯 What This Creates

### AWS Resources

1. **RDS PostgreSQL Database**
   - Instance: db.t3.micro (free tier)
   - Storage: 20 GB (free tier)
   - Public accessibility enabled
   - Automated backups configured
   - Security group with PostgreSQL access

2. **S3 Buckets**
   - Frontend hosting bucket (with static website hosting)
   - Media storage bucket (for user uploads)
   - Public read access configured
   - CORS configuration
   - Bucket policies

3. **IAM User for Deployment**
   - Programmatic access user
   - S3 full access
   - Elastic Beanstalk admin permissions
   - Access keys automatically generated

4. **Security Groups**
   - RDS security group (PostgreSQL access)
   - Elastic Beanstalk security group (HTTP/HTTPS)

5. **IAM Role for Elastic Beanstalk**
   - EC2 instance profile
   - Required permissions for EB

6. **Random Resources**
   - JWT secret (automatically generated)
   - Unique suffixes for resource names

## 📋 Prerequisites

### 1. Install Terraform

**macOS:**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

**Linux:**
```bash
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
```

**Windows:**
Download from [terraform.io](https://www.terraform.io/downloads.html) or use Chocolatey:
```powershell
choco install terraform
```

### 2. Install AWS CLI

If not already installed:
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Windows - Download installer from aws.amazon.com/cli
```

### 3. Configure AWS Credentials

You need AWS credentials with admin access (for initial setup):

```bash
aws configure
# AWS Access Key ID: [Your access key]
# AWS Secret Access Key: [Your secret key]
# Default region name: us-east-1
# Default output format: json
```

**Note:** These are YOUR personal AWS credentials for running Terraform. The script will create a separate IAM user for CircleCI deployments.

## 🚀 Quick Start

### Step 1: Prepare Configuration

```bash
# Navigate to terraform directory
cd terraform

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your preferred text editor
nano terraform.tfvars
# OR
code terraform.tfvars
# OR
vim terraform.tfvars
```

**Important:** Update the `db_password` in `terraform.tfvars` with a strong password!

### Step 2: Initialize Terraform

```bash
terraform init
```

This downloads the required providers (AWS, Random).

### Step 3: Review the Plan

```bash
terraform plan
```

This shows you what will be created. Review carefully!

Expected resources: **~30 resources** to be created.

### Step 4: Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted.

⏱️ **This will take 5-10 minutes** (mostly waiting for RDS database creation).

### Step 5: Save the Outputs

After successful creation, Terraform will display all the important values:

```bash
# To see the output again
terraform output summary

# To save to a file
terraform output summary > infrastructure-details.txt

# To get specific values
terraform output rds_address
terraform output s3_frontend_bucket
terraform output -raw iam_access_key_id
terraform output -raw iam_secret_access_key
```

## 📝 Configuration Options

### Variables You Can Customize

Edit `terraform.tfvars` to customize:

```hcl
# Region
aws_region = "us-east-1"  # or us-west-2, eu-west-1, etc.

# Project naming
project_name = "udagram"
environment  = "dev"

# Database
db_username = "postgres"
db_password = "YourSecurePassword123!"  # REQUIRED: Change this!
db_instance_class = "db.t3.micro"       # or db.t3.small for better performance
db_allocated_storage = 20               # GB

# PostgreSQL version
postgres_engine_version = "13.13"       # or "14.9", "15.4"
```

## 🔐 Security Notes

### Terraform State File

The `terraform.tfstate` file contains **sensitive information** including:
- Database passwords
- Access keys
- Security group IDs

**Important:**
- ✅ Already in `.gitignore` - DO NOT commit to Git
- ✅ Store securely (password manager, encrypted storage)
- ✅ For production, use [Terraform Cloud](https://cloud.hashicorp.com/products/terraform) or S3 backend

### Access Keys

The IAM user access keys are shown in the output. Save them immediately:

```bash
# Save to secure file
terraform output -raw iam_access_key_id > access_key_id.txt
terraform output -raw iam_secret_access_key > secret_access_key.txt

# Or better: use a password manager
terraform output iam_access_key_id
terraform output iam_secret_access_key
```

## 🧪 Testing the Infrastructure

### Test 1: Database Connection

```bash
# Get database endpoint
DB_HOST=$(terraform output -raw rds_address)
DB_USER=$(terraform output -raw rds_username)

# Connect (enter password when prompted)
psql -h $DB_HOST -U $DB_USER -d postgres

# In psql prompt:
\l          # List databases
\q          # Quit
```

### Test 2: S3 Bucket Access

```bash
# Get bucket name
BUCKET=$(terraform output -raw s3_frontend_bucket)

# Create test file
echo "Hello Udagram!" > test.html

# Upload to S3
aws s3 cp test.html s3://$BUCKET/ --acl public-read

# Get website URL
WEBSITE_URL=$(terraform output -raw s3_frontend_website_url)

# Visit in browser or curl
curl $WEBSITE_URL/test.html
```

### Test 3: IAM User Credentials

```bash
# Get access key
ACCESS_KEY=$(terraform output -raw iam_access_key_id)
SECRET_KEY=$(terraform output -raw iam_secret_access_key)

# Test credentials
AWS_ACCESS_KEY_ID=$ACCESS_KEY \
AWS_SECRET_ACCESS_KEY=$SECRET_KEY \
aws s3 ls
```

## 📊 Managing Infrastructure

### View Current State

```bash
# List all resources
terraform state list

# Show specific resource
terraform state show aws_db_instance.postgres

# View outputs
terraform output
```

### Update Infrastructure

```bash
# Modify terraform.tfvars or *.tf files
nano terraform.tfvars

# Preview changes
terraform plan

# Apply changes
terraform apply
```

### Destroy Infrastructure

⚠️ **WARNING:** This will delete ALL resources including the database!

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy

# Type 'yes' when prompted
```

## 🎯 Next Steps After Terraform Apply

1. **Save All Outputs**
   ```bash
   terraform output summary > infrastructure-setup.txt
   ```

2. **Configure Local Environment**
   ```bash
   cd ../udagram
   
   # Create local env file
   cat > set_env.sh.local << EOF
   export POSTGRES_USERNAME=$(cd ../terraform && terraform output -raw rds_username)
   export POSTGRES_PASSWORD=YOUR_DB_PASSWORD
   export POSTGRES_HOST=$(cd ../terraform && terraform output -raw rds_address)
   export POSTGRES_DB=$(cd ../terraform && terraform output -raw rds_database_name)
   export AWS_BUCKET=$(cd ../terraform && terraform output -raw s3_media_bucket)
   export AWS_REGION=$(cd ../terraform && terraform output -raw aws_region)
   export JWT_SECRET=$(cd ../terraform && terraform output -raw jwt_secret)
   export URL=http://localhost:8100
   EOF
   
   source set_env.sh.local
   ```

3. **Test Local Connection**
   ```bash
   cd udagram-api
   npm install
   npm run dev
   ```

4. **Create Elastic Beanstalk Environment**
   ```bash
   cd udagram-api
   eb init
   eb create --single --instance-types t2.medium
   ```

5. **Set EB Environment Variables**
   ```bash
   # Get values from Terraform
   cd ../../terraform
   
   eb setenv \
     POSTGRES_USERNAME=$(terraform output -raw rds_username) \
     POSTGRES_PASSWORD=YOUR_DB_PASSWORD \
     POSTGRES_HOST=$(terraform output -raw rds_address) \
     POSTGRES_DB=$(terraform output -raw rds_database_name) \
     AWS_BUCKET=$(terraform output -raw s3_media_bucket) \
     AWS_REGION=$(terraform output -raw aws_region) \
     JWT_SECRET=$(terraform output -raw jwt_secret) \
     URL=$(terraform output -raw s3_frontend_website_url)
   ```

6. **Configure CircleCI**
   - Go to CircleCI project settings
   - Add environment variables from Terraform outputs
   - Use the `terraform output` commands to get values

7. **Update Frontend Configuration**
   - Update `environment.prod.ts` with your EB URL
   - Update and commit changes

## 🐛 Troubleshooting

### Error: "Error creating DB Instance: InvalidParameterValue"

**Problem:** Invalid database password or configuration.

**Solution:**
- Ensure password is at least 8 characters
- Avoid special characters like `@`, `/`, `"`
- Use alphanumeric + common special chars (!#$%^&*)

### Error: "Error creating S3 bucket: BucketAlreadyExists"

**Problem:** Bucket name collision (bucket names are globally unique).

**Solution:**
```bash
# Destroy and recreate with new random suffix
terraform destroy -target=random_id.suffix
terraform apply
```

### Error: "UnauthorizedOperation"

**Problem:** AWS credentials don't have sufficient permissions.

**Solution:**
- Verify AWS CLI is configured: `aws sts get-caller-identity`
- Ensure your IAM user has admin access (for initial setup)
- Check `aws configure list`

### Database Connection Refused

**Problem:** Security group not configured or RDS not ready.

**Solution:**
```bash
# Check RDS status
aws rds describe-db-instances --db-instance-identifier $(terraform output -raw rds_database_name)

# Wait for status: available

# Verify security group
terraform output | grep security_group
```

### Terraform State Locked

**Problem:** Previous operation didn't complete.

**Solution:**
```bash
# Force unlock (use carefully!)
terraform force-unlock LOCK_ID

# Or wait a few minutes and retry
```

## 💰 Cost Estimation

### Free Tier (First 12 Months)

- **RDS db.t3.micro**: 750 hours/month = $0
- **EC2 t2.micro** (via EB): 750 hours/month = $0
- **S3 Storage**: 5 GB = $0
- **Data Transfer**: 15 GB out = $0

**Monthly Cost: $0** (within free tier limits)

### After Free Tier

- **RDS db.t3.micro**: ~$15/month
- **EC2 t2.medium**: ~$35/month
- **S3 + Data Transfer**: ~$5/month

**Estimated Monthly Cost: ~$55**

### Cost Optimization Tips

1. **Stop when not in use:**
   ```bash
   terraform destroy  # When done testing
   ```

2. **Use smaller instances:**
   - Development: t2.micro
   - Production: t2.small or t3.small

3. **Delete old snapshots:**
   - RDS automatic backups (included)
   - Manual snapshots cost $0.095/GB-month

4. **Monitor usage:**
   - AWS Cost Explorer
   - Set up billing alerts

## 📚 Additional Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform CLI Documentation](https://www.terraform.io/docs/cli/index.html)
- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)

## 🆘 Getting Help

If you encounter issues:

1. Check Terraform output for error messages
2. Review `terraform.log` (set `TF_LOG=DEBUG`)
3. Verify AWS credentials and permissions
4. Check AWS Console for resource status
5. Review this README and troubleshooting section

## 🎉 Success!

If everything worked, you should see a nice formatted output with all your infrastructure details. Save these values securely and proceed with the Elastic Beanstalk setup!

---

**Next:** Follow the [DEPLOYMENT_CHECKLIST.md](../DEPLOYMENT_CHECKLIST.md) to complete your deployment.

