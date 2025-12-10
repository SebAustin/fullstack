# Terraform Quick Start Guide 🚀

Get your entire AWS infrastructure up and running in under 10 minutes!

## Prerequisites Checklist

Before you start, ensure you have:

- [ ] AWS Account created
- [ ] Terraform installed (`terraform version`)
- [ ] AWS CLI installed (`aws --version`)
- [ ] AWS CLI configured (`aws sts get-caller-identity`)

## 🎯 Super Quick Start (3 Commands)

```bash
# 1. Navigate to terraform directory
cd terraform

# 2. Setup your configuration
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit: Change db_password!

# 3. Deploy everything!
./deploy.sh
```

That's it! The script will handle everything else.

## 📝 Detailed Step-by-Step

### Step 1: Install Terraform

**macOS:**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
terraform version
```

**Windows (PowerShell as Administrator):**
```powershell
choco install terraform
terraform version
```

### Step 2: Configure AWS CLI

```bash
aws configure
```

Enter your AWS credentials:
```
AWS Access Key ID [None]: YOUR_ACCESS_KEY
AWS Secret Access Key [None]: YOUR_SECRET_KEY
Default region name [None]: us-east-1
Default output format [None]: json
```

Verify it works:
```bash
aws sts get-caller-identity
```

### Step 3: Configure Terraform Variables

```bash
cd terraform

# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit the file
nano terraform.tfvars
# OR
code terraform.tfvars
# OR
vim terraform.tfvars
```

**Required Changes:**

```hcl
# MUST CHANGE THIS! Use a strong password
db_password = "YourSecurePassword123!"

# Optional: Customize these
aws_region   = "us-east-1"
project_name = "udagram"
db_username  = "postgres"
```

### Step 4: Deploy with Automated Script

```bash
./deploy.sh
```

The script will:
1. ✅ Check prerequisites
2. ✅ Initialize Terraform
3. ✅ Validate configuration
4. ✅ Show deployment plan
5. ✅ Ask for confirmation
6. ✅ Create all resources (5-10 minutes)
7. ✅ Save outputs to file
8. ✅ Display next steps

### Step 5: Save the Outputs

After deployment completes, you'll see a formatted output with all your infrastructure details.

**Save it now!**

```bash
# Already saved automatically to:
cat infrastructure-details.txt

# Or view again anytime:
terraform output summary

# Get specific values:
terraform output rds_address
terraform output s3_frontend_bucket
terraform output -raw iam_access_key_id
terraform output -raw iam_secret_access_key
```

## 🔧 Manual Deployment (Alternative)

If you prefer to run commands manually:

```bash
cd terraform

# 1. Initialize
terraform init

# 2. Validate
terraform validate

# 3. Plan (preview changes)
terraform plan

# 4. Apply (create resources)
terraform apply
# Type 'yes' when prompted

# 5. View outputs
terraform output summary
```

## 📊 What Gets Created

Your Terraform deployment creates:

### AWS Resources (Approximate Cost: FREE for first year)

| Resource | Type | Cost |
|----------|------|------|
| RDS PostgreSQL | db.t3.micro | Free tier |
| S3 Buckets | 2 buckets | Free tier |
| IAM User | Deployer | Free |
| Security Groups | 2 groups | Free |
| IAM Role | For EB | Free |

**Total Monthly Cost:**
- First 12 months: **$0** (free tier)
- After free tier: **~$15-25/month**

### Detailed Resources List

1. **RDS Database**
   - ✅ PostgreSQL 13
   - ✅ db.t3.micro instance
   - ✅ 20 GB storage
   - ✅ Public accessibility
   - ✅ Automated backups

2. **S3 Buckets**
   - ✅ Frontend hosting bucket
   - ✅ Media storage bucket
   - ✅ Static website hosting enabled
   - ✅ Public read access configured
   - ✅ CORS enabled

3. **IAM Resources**
   - ✅ Deployer user with access keys
   - ✅ S3 full access
   - ✅ Elastic Beanstalk admin access
   - ✅ EC2 instance profile for EB

4. **Security Groups**
   - ✅ RDS security group (PostgreSQL)
   - ✅ EB security group (HTTP/HTTPS)

5. **Generated Secrets**
   - ✅ JWT secret (32 characters)
   - ✅ Unique resource IDs

## ✅ Verify Deployment

### Test 1: Database Connection

```bash
# Get database host
DB_HOST=$(terraform output -raw rds_address)

# Connect (enter password when prompted)
psql -h $DB_HOST -U postgres -d postgres

# Success if you see:
# postgres=>
```

### Test 2: S3 Bucket

```bash
# Get bucket name
BUCKET=$(terraform output -raw s3_frontend_bucket)

# List bucket (should be empty)
aws s3 ls s3://$BUCKET/

# Upload test file
echo "Hello!" > test.txt
aws s3 cp test.txt s3://$BUCKET/ --acl public-read

# Get website URL
terraform output -raw s3_frontend_website_url
# Visit this URL in your browser
```

### Test 3: IAM User

```bash
# Get credentials
ACCESS_KEY=$(terraform output -raw iam_access_key_id)
SECRET_KEY=$(terraform output -raw iam_secret_access_key)

# Test with temporary credentials
AWS_ACCESS_KEY_ID=$ACCESS_KEY \
AWS_SECRET_ACCESS_KEY=$SECRET_KEY \
aws s3 ls
```

## 🎯 Next Steps After Terraform

Once Terraform completes successfully:

### 1. Configure Local Development

```bash
cd ../udagram

# Create local environment file
cat > set_env.sh.local << 'EOF'
export POSTGRES_USERNAME=postgres
export POSTGRES_PASSWORD=YOUR_DB_PASSWORD
export POSTGRES_HOST=$(cd ../terraform && terraform output -raw rds_address)
export POSTGRES_DB=postgres
export AWS_BUCKET=$(cd ../terraform && terraform output -raw s3_media_bucket)
export AWS_REGION=us-east-1
export JWT_SECRET=$(cd ../terraform && terraform output -raw jwt_secret)
export URL=http://localhost:8100
EOF

# Load environment
source set_env.sh.local
```

### 2. Create Elastic Beanstalk Environment

```bash
cd udagram-api

# Install dependencies and build
npm install
npm run build

# Initialize EB
eb init
# Follow prompts:
# - Region: us-east-1
# - Application: udagram-api
# - Platform: Node.js 14
# - SSH: Yes

# Create environment
eb create udagram-api-dev --single --instance-types t2.medium

# This takes 5-10 minutes
```

### 3. Configure EB Environment Variables

```bash
cd ../../terraform

# Set all environment variables in EB
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

### 4. Update Frontend Configuration

Get your EB URL:
```bash
cd ../udagram/udagram-api
eb status | grep CNAME
```

Update `udagram/udagram-frontend/src/environments/environment.prod.ts`:
```typescript
apiHost: "http://YOUR-EB-URL-HERE/api/v0"
```

### 5. Set Up CircleCI

Add these environment variables in CircleCI (get from terraform outputs):

```bash
cd ../terraform

# AWS Credentials
AWS_ACCESS_KEY_ID=$(terraform output -raw iam_access_key_id)
AWS_SECRET_ACCESS_KEY=$(terraform output -raw iam_secret_access_key)

# AWS Configuration
AWS_REGION=$(terraform output -raw aws_region)
AWS_DEFAULT_REGION=$(terraform output -raw aws_region)
AWS_BUCKET=$(terraform output -raw s3_frontend_bucket)

# Database
POSTGRES_USERNAME=$(terraform output -raw rds_username)
POSTGRES_PASSWORD=[Your DB password]
POSTGRES_HOST=$(terraform output -raw rds_address)
POSTGRES_DB=$(terraform output -raw rds_database_name)

# Application
JWT_SECRET=$(terraform output -raw jwt_secret)
URL=$(terraform output -raw s3_frontend_website_url)
```

## 🛠️ Common Operations

### View Infrastructure Status

```bash
# List all resources
terraform state list

# Show specific resource
terraform state show aws_db_instance.postgres

# View outputs again
terraform output summary
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

⚠️ **WARNING:** This deletes EVERYTHING including the database!

```bash
# Using the script (safer - asks for confirmation)
./deploy.sh destroy

# OR manually
terraform destroy
```

## 🐛 Troubleshooting

### Error: "command not found: terraform"

**Solution:**
```bash
# Install Terraform
brew install terraform  # macOS
# OR download from terraform.io
```

### Error: "Unable to locate credentials"

**Solution:**
```bash
aws configure
# Enter your AWS credentials
```

### Error: "InvalidParameterValue: Invalid DB password"

**Solution:**
- Password must be 8+ characters
- Use letters, numbers, and common special chars (!#$%^&*)
- Avoid: @ / " '

### Error: "BucketAlreadyExists"

**Solution:**
```bash
# Bucket names must be globally unique
# Destroy and recreate with new random suffix
terraform destroy -target=random_id.suffix
terraform apply
```

### Resources Taking Too Long

**Normal times:**
- RDS Database: 5-8 minutes ⏰
- S3 Buckets: 10 seconds ⚡
- IAM Resources: 30 seconds ⚡
- Total: 5-10 minutes ⏰

If stuck for >15 minutes:
```bash
# Check AWS Console for errors
# OR cancel and retry
Ctrl+C
terraform apply
```

## 💡 Pro Tips

### 1. Save Credentials Securely

```bash
# Save to 1Password, LastPass, etc.
terraform output -raw iam_access_key_id
terraform output -raw iam_secret_access_key

# Or to encrypted files
terraform output -raw iam_access_key_id | gpg -e > access_key.gpg
```

### 2. Use Environment Variables

```bash
# Instead of typing repeatedly
export DB_HOST=$(cd terraform && terraform output -raw rds_address)
export BUCKET=$(cd terraform && terraform output -raw s3_frontend_bucket)

psql -h $DB_HOST -U postgres -d postgres
```

### 3. Create Multiple Environments

```bash
# Development
terraform workspace new dev
terraform apply -var-file=dev.tfvars

# Production
terraform workspace new prod
terraform apply -var-file=prod.tfvars
```

### 4. Keep Costs Low

- ✅ Use t2.micro/t3.micro instances (free tier)
- ✅ Stop/destroy when not actively developing
- ✅ Set up billing alerts in AWS Console
- ✅ Monitor free tier usage

## 📚 Additional Resources

- **Full Documentation**: [README.md](README.md)
- **Terraform Docs**: [terraform.io/docs](https://terraform.io/docs)
- **AWS Free Tier**: [aws.amazon.com/free](https://aws.amazon.com/free)
- **Deployment Checklist**: [../DEPLOYMENT_CHECKLIST.md](../DEPLOYMENT_CHECKLIST.md)

## 🆘 Need Help?

1. Check [terraform/README.md](README.md) for detailed docs
2. Review error messages carefully
3. Check AWS Console for resource status
4. Verify AWS credentials: `aws sts get-caller-identity`
5. Check Terraform version: `terraform version`

## ✨ Success Criteria

Your deployment is successful when:

✅ Terraform apply completes without errors
✅ `infrastructure-details.txt` file is created
✅ Can connect to database with psql
✅ Can access S3 bucket website URL
✅ IAM user credentials work with AWS CLI
✅ All outputs show valid values

**Ready to deploy? Run `./deploy.sh` and let's go! 🚀**

