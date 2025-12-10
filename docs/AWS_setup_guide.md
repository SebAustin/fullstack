# AWS Setup Guide

This guide provides detailed, step-by-step instructions for setting up all required AWS resources for deploying the Udagram application.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [AWS Account Setup](#aws-account-setup)
3. [Create RDS PostgreSQL Database](#create-rds-postgresql-database)
4. [Create S3 Buckets](#create-s3-buckets)
5. [Create IAM User for Deployment](#create-iam-user-for-deployment)
6. [Setup Elastic Beanstalk](#setup-elastic-beanstalk)
7. [Configure Environment Variables](#configure-environment-variables)
8. [Test the Setup](#test-the-setup)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

Before starting, ensure you have:

- An AWS account (free tier eligible)
- AWS CLI v2 installed and configured
- EB CLI installed
- Node.js 14.15.0 installed
- PostgreSQL client (psql) installed
- Basic knowledge of AWS services

### Install Required Tools

#### AWS CLI

**macOS:**
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version
```

**Linux:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

**Windows:**
Download and run the AWS CLI MSI installer from [AWS CLI Downloads](https://aws.amazon.com/cli/)

#### Elastic Beanstalk CLI

```bash
pip install awsebcli --upgrade --user
eb --version
```

#### PostgreSQL Client

**macOS:**
```bash
brew install postgresql
psql --version
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install postgresql-client
psql --version
```

**Windows:**
Download from [PostgreSQL Downloads](https://www.postgresql.org/download/windows/)

## AWS Account Setup

### 1. Create AWS Account

1. Go to [aws.amazon.com](https://aws.amazon.com)
2. Click "Create an AWS Account"
3. Follow the registration process
4. Provide payment information (required, but free tier available)
5. Verify your email and phone number

### 2. Select AWS Region

Choose a region close to your target users. This guide uses `us-east-1` (N. Virginia), but you can use any region.

**Recommended regions:**
- `us-east-1` - US East (N. Virginia)
- `us-west-2` - US West (Oregon)
- `eu-west-1` - Europe (Ireland)
- `ap-southeast-1` - Asia Pacific (Singapore)

**Note:** Use the same region for all services in this project.

## Create RDS PostgreSQL Database

### Step 1: Navigate to RDS

1. Log into [AWS Console](https://console.aws.amazon.com)
2. Search for "RDS" in the services search bar
3. Click on "RDS" to open the RDS dashboard

### Step 2: Create Database

1. Click **"Create database"** button
2. Choose **"Standard create"** (not Easy create)

### Step 3: Engine Options

- **Engine type**: PostgreSQL
- **Version**: PostgreSQL 13.x (or 12.x)
- Leave other engine options as default

### Step 4: Templates

- Select **"Free tier"** (if eligible)
- Or select **"Dev/Test"** if free tier not available

### Step 5: Settings

**DB instance identifier:** `udagram-database` (or your preferred name)

**Master username:** `postgres` (or your preferred username)

**Master password:** Create a strong password
- Use at least 8 characters
- Include uppercase, lowercase, numbers
- Save this password securely - you'll need it later

**Confirm password:** Re-enter your password

### Step 6: Instance Configuration

**DB instance class:**
- Free tier: `db.t3.micro` or `db.t2.micro`
- Production: `db.t3.small` or larger

**Storage:**
- Storage type: General Purpose (SSD)
- Allocated storage: 20 GB (free tier limit)
- Uncheck "Enable storage autoscaling" (for cost control)

### Step 7: Connectivity

**Virtual Private Cloud (VPC):** Default VPC

**Subnet group:** default

**Public access:** **YES** ✅ (Important!)
> This allows your local machine and Elastic Beanstalk to connect to the database

**VPC security group:**
- Choose existing: `default`
- Or create new: `udagram-rds-sg`

**Availability Zone:** No preference

**Database port:** `5432` (default PostgreSQL port)

### Step 8: Database Authentication

- Select **"Password authentication"**

### Step 9: Additional Configuration

Click **"Additional configuration"** to expand

**Initial database name:** `postgres` ✅ (Important!)
> If you don't specify this, AWS won't create a database

**DB parameter group:** default.postgres13 (or your version)

**Backup:**
- Enable automated backups: Yes
- Backup retention period: 7 days
- Backup window: No preference

**Encryption:** Enable encryption (recommended)

**Performance Insights:** Disable (not needed for development)

**Monitoring:** Enable enhanced monitoring (optional)

**Maintenance:**
- Enable auto minor version upgrade: Yes
- Maintenance window: No preference

### Step 10: Create Database

1. Review all settings
2. Click **"Create database"**
3. Wait 5-10 minutes for database creation

### Step 11: Note Database Details

Once created, click on your database instance and note:

- **Endpoint:** `udagram-database.xxxxxx.us-east-1.rds.amazonaws.com`
- **Port:** `5432`
- **Master username:** `postgres`
- **Database name:** `postgres`

Save these details - you'll need them for environment variables!

### Step 12: Configure Security Group

1. In RDS dashboard, click on your database
2. Under **"Connectivity & security"**, click on the VPC security group
3. Click **"Edit inbound rules"**
4. Click **"Add rule"**
   - Type: PostgreSQL
   - Protocol: TCP
   - Port: 5432
   - Source: 
     - For development: `0.0.0.0/0` (anywhere)
     - For production: Your IP and EB security group
5. Click **"Save rules"**

⚠️ **Security Note:** Using `0.0.0.0/0` allows access from anywhere. For production, restrict to specific IPs and security groups.

### Step 13: Test Connection

From your local machine:

```bash
psql -h udagram-database.xxxxxx.us-east-1.rds.amazonaws.com -U postgres -d postgres
# Enter your password when prompted
```

If connection succeeds, you'll see:
```
postgres=>
```

Test some commands:
```sql
\l          -- List databases
\q          -- Quit
```

## Create S3 Buckets

You need two S3 buckets:
1. Frontend hosting (static website)
2. Media storage (uploaded images) - optional, can use same bucket

### Bucket 1: Frontend Hosting

#### Step 1: Navigate to S3

1. In AWS Console, search for "S3"
2. Click **"Create bucket"**

#### Step 2: Bucket Settings

**Bucket name:** `udagram-frontend-YYYYMMDD-UNIQUEID`
- Must be globally unique
- Example: `udagram-frontend-20241204-12345`
- Use lowercase letters, numbers, and hyphens only

**AWS Region:** Select your region (e.g., us-east-1)

**Object Ownership:**
- Select **"ACLs enabled"**
- Select **"Bucket owner preferred"**

**Block Public Access:**
- **UNCHECK** "Block all public access" ⚠️
- Check the acknowledgment box

**Bucket Versioning:** Disabled (optional: enable for backup)

**Tags:** (optional)
- Key: `Project`, Value: `Udagram`
- Key: `Environment`, Value: `Production`

**Default encryption:** Server-side encryption (SSE-S3)

**Advanced settings:** Leave as default

#### Step 3: Create Bucket

Click **"Create bucket"**

#### Step 4: Enable Static Website Hosting

1. Click on your newly created bucket
2. Go to **"Properties"** tab
3. Scroll to **"Static website hosting"**
4. Click **"Edit"**
5. Select **"Enable"**
6. Index document: `index.html`
7. Error document: `index.html` (for Angular routing)
8. Click **"Save changes"**
9. Note the **Bucket website endpoint** URL

#### Step 5: Configure Bucket Policy

1. Go to **"Permissions"** tab
2. Scroll to **"Bucket policy"**
3. Click **"Edit"**
4. Paste the following policy (replace `YOUR-BUCKET-NAME`):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```

5. Click **"Save changes"**

#### Step 6: Configure CORS

1. Still in **"Permissions"** tab
2. Scroll to **"Cross-origin resource sharing (CORS)"**
3. Click **"Edit"**
4. Paste the following CORS configuration:

```json
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "HEAD",
            "PUT",
            "POST",
            "DELETE"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "ETag",
            "x-amz-meta-custom-header"
        ],
        "MaxAgeSeconds": 3000
    }
]
```

5. Click **"Save changes"**

### Bucket 2: Media Storage (Optional - Use Same Bucket)

For simplicity, you can use the same bucket for frontend and media storage, or create a separate bucket following the same steps above but with a different name (e.g., `udagram-media-YYYYMMDD-UNIQUEID`).

For this project, we'll use the frontend bucket for both purposes.

## Create IAM User for Deployment

### Step 1: Navigate to IAM

1. In AWS Console, search for "IAM"
2. Click on **"Users"** in the left sidebar
3. Click **"Add users"**

### Step 2: User Details

**User name:** `udagram-circleci-deployer`

**Access type:**
- Check ✅ **"Programmatic access"** (for API access)
- Uncheck "AWS Management Console access"

Click **"Next: Permissions"**

### Step 3: Set Permissions

1. Select **"Attach existing policies directly"**
2. Search and select the following policies:
   - ✅ `AmazonS3FullAccess`
   - ✅ `AdministratorAccess-AWSElasticBeanstalk`
   - ✅ `AWSElasticBeanstalkWebTier`
   - ✅ `AWSElasticBeanstalkWorkerTier`
   - ✅ `AWSElasticBeanstalkMulticontainerDocker`

3. Click **"Next: Tags"**

### Step 4: Add Tags (Optional)

- Key: `Project`, Value: `Udagram`
- Key: `Purpose`, Value: `CircleCI Deployment`

Click **"Next: Review"**

### Step 5: Review and Create

1. Review all settings
2. Click **"Create user"**

### Step 6: Save Credentials

⚠️ **IMPORTANT:** This is your only chance to see the secret access key!

1. **Access key ID:** `AKIAxxxxxxxxxxxxxxxx`
2. **Secret access key:** `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

**Save these credentials securely:**
- Download the .csv file
- Copy to a password manager
- Store in a secure location

You'll need these for:
- AWS CLI configuration
- CircleCI environment variables

Click **"Close"**

### Step 7: Configure AWS CLI

```bash
aws configure
# AWS Access Key ID: [paste your access key]
# AWS Secret Access Key: [paste your secret key]
# Default region name: us-east-1
# Default output format: json

# Test the configuration
aws s3 ls
aws iam get-user
```

## Setup Elastic Beanstalk

### Step 1: Initialize Elastic Beanstalk

Navigate to your backend API directory:

```bash
cd udagram/udagram-api
```

### Step 2: Initialize EB

```bash
eb init
```

You'll be prompted with several questions:

**Select a default region:**
```
Select a default region
1) us-east-1 : US East (N. Virginia)
2) us-west-1 : US West (N. California)
...
(default is 3): 1
```
Choose your region (e.g., 1 for us-east-1)

**Select an application to use:**
```
Select an application to use
1) [ Create new Application ]
(default is 1): 1
```
Press Enter to create new application

**Enter Application Name:**
```
Enter Application Name
(default is "udagram-api"): udagram-api
```
Press Enter to use default or type your preferred name

**Select a platform:**
```
Select a platform.
1) .NET Core on Linux
2) Docker
3) Go
4) Java
5) Node.js
6) PHP
...
(default is 1): 5
```
Select `5` for Node.js

**Select a platform branch:**
```
Select a platform branch.
1) Node.js 16 running on 64bit Amazon Linux 2
2) Node.js 14 running on 64bit Amazon Linux 2
3) Node.js 12 running on 64bit Amazon Linux 2
(default is 1): 2
```
Select `2` for Node.js 14

**Do you wish to continue with CodeCommit?**
```
Do you wish to continue with CodeCommit? (Y/n): n
```
Type `n` and press Enter

**Do you want to set up SSH for your instances?**
```
Do you want to set up SSH for your instances?
(Y/n): Y
```
Type `Y` if you want SSH access (recommended for debugging)

**Select a keypair:**
```
Select a keypair.
1) [ Create new KeyPair ]
(default is 1): 1
```

If you don't have a keypair, create one:
```
Type a keypair name.
(default is aws-eb): udagram-keypair
```

This creates `.elasticbeanstalk/config.yml` in your API directory.

### Step 3: Create EB Environment

⚠️ **Important:** Before creating the environment, ensure you've built your application:

```bash
npm install
npm run build
```

Now create the environment:

```bash
eb create udagram-api-dev --single --instance-types t2.medium
```

**Command breakdown:**
- `udagram-api-dev` - Environment name
- `--single` - Single instance (no load balancer) for free tier
- `--instance-types t2.medium` - Instance type (t2.medium recommended, t2.micro may be too small)

Alternative with more options:

```bash
eb create udagram-api-dev \
  --single \
  --instance-types t2.medium \
  --keyname udagram-keypair \
  --platform "Node.js 14 running on 64bit Amazon Linux 2" \
  --region us-east-1
```

This process takes 5-10 minutes. You'll see output like:

```
Creating application version archive "app-241204_123456".
Uploading udagram-api/app-241204_123456.zip to S3...
Environment details for: udagram-api-dev
  Application name: udagram-api
  Region: us-east-1
  ...
Printing Status:
2024-12-04 12:35:00    INFO    createEnvironment is starting.
2024-12-04 12:35:30    INFO    Using elasticbeanstalk-us-east-1-xxxxx as Amazon S3 storage bucket.
...
2024-12-04 12:40:00    INFO    Successfully launched environment: udagram-api-dev
```

### Step 4: Verify Environment

```bash
# Check environment status
eb status

# View environment in browser
eb open
```

You should see your environment URL:
```
http://udagram-api-dev.eba-xxxxx.us-east-1.elasticbeanstalk.com
```

### Step 5: View and Configure EB in Console

1. Go to AWS Console > Elastic Beanstalk
2. Click on your application: `udagram-api`
3. Click on your environment: `udagram-api-dev`
4. Verify health status is **Green**

## Configure Environment Variables

### Step 1: Set Variables in Elastic Beanstalk

#### Via Console:

1. AWS Console > Elastic Beanstalk > `udagram-api-dev`
2. Click **"Configuration"** in left sidebar
3. Find **"Software"** category
4. Click **"Edit"**
5. Scroll to **"Environment properties"**
6. Add the following variables:

| Name | Value | Example |
|------|-------|---------|
| `POSTGRES_USERNAME` | Your DB username | `postgres` |
| `POSTGRES_PASSWORD` | Your DB password | `YourSecurePassword123!` |
| `POSTGRES_HOST` | Your RDS endpoint | `udagram-db.xxx.us-east-1.rds.amazonaws.com` |
| `POSTGRES_DB` | Database name | `postgres` |
| `AWS_BUCKET` | S3 bucket name | `udagram-frontend-20241204-12345` |
| `AWS_REGION` | Your AWS region | `us-east-1` |
| `JWT_SECRET` | Random secret string | `mySecureJWTSecret123456!` |
| `URL` | Frontend URL | `http://your-bucket.s3-website-us-east-1.amazonaws.com` |

7. Click **"Apply"**
8. Wait for environment update (2-5 minutes)

#### Via EB CLI:

```bash
cd udagram/udagram-api

eb setenv \
  POSTGRES_USERNAME=postgres \
  POSTGRES_PASSWORD=YourSecurePassword123! \
  POSTGRES_HOST=udagram-db.xxx.us-east-1.rds.amazonaws.com \
  POSTGRES_DB=postgres \
  AWS_BUCKET=udagram-frontend-20241204-12345 \
  AWS_REGION=us-east-1 \
  JWT_SECRET=mySecureJWTSecret123456! \
  URL=http://your-bucket.s3-website-us-east-1.amazonaws.com
```

### Step 2: Set Variables in CircleCI

1. Go to [circleci.com](https://circleci.com)
2. Navigate to your project
3. Click **"Project Settings"**
4. Click **"Environment Variables"** in left sidebar
5. Add the following variables:

**AWS Credentials:**
- `AWS_ACCESS_KEY_ID` - Your IAM user access key
- `AWS_SECRET_ACCESS_KEY` - Your IAM user secret key

**AWS Configuration:**
- `AWS_REGION` - `us-east-1`
- `AWS_DEFAULT_REGION` - `us-east-1` (same as AWS_REGION)
- `AWS_BUCKET` - Your S3 bucket name

**Database:**
- `POSTGRES_USERNAME` - Database username
- `POSTGRES_PASSWORD` - Database password
- `POSTGRES_HOST` - RDS endpoint
- `POSTGRES_DB` - `postgres`

**Application:**
- `JWT_SECRET` - Your JWT secret
- `URL` - Frontend URL

### Step 3: Update Local Environment

Create `udagram/set_env.sh.local` (not tracked by git):

```bash
export POSTGRES_USERNAME=postgres
export POSTGRES_PASSWORD=YourSecurePassword123!
export POSTGRES_HOST=udagram-db.xxx.us-east-1.rds.amazonaws.com
export POSTGRES_DB=postgres
export AWS_BUCKET=udagram-frontend-20241204-12345
export AWS_REGION=us-east-1
export AWS_PROFILE=default
export JWT_SECRET=mySecureJWTSecret123456!
export URL=http://localhost:8100
```

Load variables:
```bash
source udagram/set_env.sh.local
```

## Test the Setup

### Test 1: Database Connection

```bash
psql -h your-rds-endpoint -U postgres -d postgres
```

Should connect successfully.

### Test 2: S3 Bucket Access

```bash
# Create a test file
echo "Test" > test.txt

# Upload to S3
aws s3 cp test.txt s3://your-bucket-name/test.txt --acl public-read

# Access via browser
# Visit: http://your-bucket.s3-website-us-east-1.amazonaws.com/test.txt
```

### Test 3: Local Backend with AWS Resources

```bash
cd udagram/udagram-api
source ../set_env.sh.local
npm run dev
```

Visit http://localhost:8080/api/v0/feed

Should see: `[]` (empty array) or feed items

### Test 4: Deploy Backend to EB

```bash
cd udagram/udagram-api
npm run deploy
```

Visit: http://your-eb-url.elasticbeanstalk.com/api/v0/feed

### Test 5: Deploy Frontend to S3

```bash
cd udagram/udagram-frontend
npm run deploy
```

Visit: http://your-bucket.s3-website-us-east-1.amazonaws.com

### Test 6: End-to-End Test

1. Visit frontend URL
2. Register a new user
3. Log in
4. Try uploading a photo
5. View feed

## Troubleshooting

### Problem: Can't Connect to RDS

**Solutions:**
1. Check security group allows your IP (port 5432)
2. Verify public accessibility is enabled
3. Check correct endpoint, username, password
4. Test with: `telnet your-rds-endpoint 5432`

### Problem: EB Environment Degraded

**Solutions:**
1. Check CloudWatch logs: `eb logs`
2. Verify environment variables are set correctly
3. SSH into instance: `eb ssh`
4. Check application logs: `/var/log/nodejs/nodejs.log`

### Problem: S3 Access Denied

**Solutions:**
1. Verify bucket policy allows public read
2. Check ACLs are enabled
3. Verify IAM user has S3 permissions
4. Check file ACL: should be public-read

### Problem: Frontend Can't Connect to API

**Solutions:**
1. Check `environment.prod.ts` has correct API URL
2. Verify CORS is configured on S3 bucket
3. Check EB environment is healthy
4. Test API directly in browser

### Problem: CircleCI Deploy Fails

**Solutions:**
1. Verify all environment variables are set in CircleCI
2. Check AWS credentials are correct
3. Verify EB environment exists: `eb list`
4. Check build logs in CircleCI dashboard

## Cost Management

### Free Tier Limits

- **RDS**: 750 hours/month of db.t2.micro or db.t3.micro
- **EC2**: 750 hours/month of t2.micro
- **S3**: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- **Data Transfer**: 15GB out per month

### Minimize Costs

1. Use single instance (no load balancer)
2. Use t2.micro or t2.small instances
3. Stop environments when not in use: `eb terminate`
4. Delete old application versions
5. Monitor AWS Billing dashboard

### Stop Resources When Not in Use

```bash
# Terminate EB environment (can recreate later)
eb terminate udagram-api-dev

# Delete RDS database (data lost!)
aws rds delete-db-instance \
  --db-instance-identifier udagram-database \
  --skip-final-snapshot
```

## Next Steps

After completing the AWS setup:

1. ✅ Test all resources are accessible
2. ✅ Update `environment.prod.ts` with actual EB URL
3. ✅ Update `deploy.sh` with actual S3 bucket name
4. ✅ Set up CircleCI project and environment variables
5. ✅ Push code to GitHub to trigger pipeline
6. ✅ Take screenshots for documentation
7. ✅ Test deployed application end-to-end

## Security Best Practices

1. **Never commit credentials** to git
2. **Rotate access keys** regularly
3. **Use IAM roles** instead of access keys when possible
4. **Enable MFA** on AWS root account
5. **Monitor CloudTrail** for suspicious activity
6. **Restrict security groups** to specific IPs in production
7. **Use HTTPS** in production (configure SSL certificate)
8. **Enable RDS encryption** at rest
9. **Regular security audits** with AWS Trusted Advisor
10. **Keep dependencies updated** with security patches

## Additional Resources

- [AWS Free Tier](https://aws.amazon.com/free/)
- [RDS User Guide](https://docs.aws.amazon.com/rds/)
- [S3 User Guide](https://docs.aws.amazon.com/s3/)
- [Elastic Beanstalk Developer Guide](https://docs.aws.amazon.com/elasticbeanstalk/)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/)
- [CircleCI Documentation](https://circleci.com/docs/)

---

**Congratulations!** You've successfully set up all AWS resources for deploying the Udagram application. 🎉

