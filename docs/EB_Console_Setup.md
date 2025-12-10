# Creating Elastic Beanstalk via AWS Console (AWS Academy Compatible)

Since AWS Academy restricts EB CLI operations, create your Elastic Beanstalk environment through the AWS Console.

## 📋 Step-by-Step Guide

### Step 1: Prepare Your Deployment Package

```bash
cd udagram/udagram-api

# Make sure you're on Node 16+
nvm use 16

# Install and build
npm install
npm run build

# Create deployment zip manually
cd www
zip -r ../udagram-api.zip .
cd ..

# Verify zip was created
ls -lh udagram-api.zip
```

### Step 2: Open AWS Console

1. Go to [AWS Console](https://console.aws.amazon.com)
2. Search for **"Elastic Beanstalk"** in the top search bar
3. Click on **Elastic Beanstalk** service

### Step 3: Create Application

1. Click **"Create Application"** button

2. **Configure Environment:**
   - Environment tier: **Web server environment**
   - Click **Next**

3. **Application Information:**
   - Application name: `udagram-api`
   - Environment name: `udagram-api-dev`
   - Domain: Leave as auto-generated (or customize)

4. **Platform:**
   - Platform: **Node.js**
   - Platform branch: **Node.js 20 running on 64bit Amazon Linux 2023**
   - Platform version: (Recommended)

5. **Application Code:**
   - Select **Upload your code**
   - Version label: `v1.0.0`
   - Click **Choose file**
   - Upload the `udagram-api.zip` file you created in Step 1

6. **Presets:**
   - Select **Single instance (free tier eligible)**

7. Click **Next**

### Step 4: Configure Service Access

**Service role:**
- Use an existing service role: Select any available
- Or create new (if allowed): `aws-elasticbeanstalk-service-role`

**EC2 instance profile:**
- Use existing: `LabInstanceProfile` (or available default)
- If not available, select `aws-elasticbeanstalk-ec2-role`

Click **Next**

### Step 5: Set Up Networking (Optional)

- VPC: Use default
- Public IP: Activated
- Instance subnets: Select at least one subnet

Click **Next**

### Step 6: Configure Instance Traffic and Scaling

**Instances:**
- Root volume: General Purpose (SSD)
- Size: 10 GB
- Instance types: **t2.medium** (or t2.micro for free tier)

**Capacity:**
- Environment type: **Single instance**

**Load balancer:** Skip (single instance mode)

Click **Next**

### Step 7: Configure Updates, Monitoring, and Logging

**Monitoring:**
- Health reporting: Enhanced

**Managed updates:**
- Leave as default or disable for now

**Rolling updates:**
- Deployment policy: All at once

Click **Next**

### Step 8: Review

Review all settings and click **Submit**

⏱️ **Wait 5-10 minutes** for environment creation.

## ⚙️ Step 9: Configure Environment Variables

After the environment is created:

1. Go to your environment: **udagram-api-dev**
2. Click **Configuration** in the left sidebar
3. Find **Software** category → Click **Edit**
4. Scroll to **Environment properties**
5. Add these variables:

```
POSTGRES_HOST=udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=[Your database password from terraform.tfvars]
POSTGRES_DB=postgres
AWS_BUCKET=udagram-media-d5acd6ba
AWS_REGION=us-east-1
JWT_SECRET=[Get from: terraform output -raw jwt_secret]
URL=http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
```

6. Click **Apply**
7. Wait 2-3 minutes for configuration update

## ✅ Step 10: Test Your API

1. In EB dashboard, find your environment URL
   - Example: `udagram-api-dev.us-east-1.elasticbeanstalk.com`

2. Test in browser:
   ```
   http://udagram-api-dev.us-east-1.elasticbeanstalk.com/api/v0/feed
   ```

3. Should see: `[]` (empty array) or feed items

## 🔄 Updating Your Application Later

### Via Console (Manual Upload)

1. Build locally: `npm run build && cd www && zip -r ../app.zip . && cd ..`
2. Go to EB Console → Application versions
3. Upload new version
4. Deploy to environment

### Via EB CLI (If Permissions Allow)

If you get EB CLI working later:

```bash
# From udagram-api directory
eb deploy
```

## 🎯 Update Frontend Configuration

Once your EB environment is running, update the frontend:

```bash
# Get your EB URL from AWS Console
# Example: udagram-api-dev.us-east-1.elasticbeanstalk.com

# Update environment.prod.ts
cd udagram-frontend/src/environments
nano environment.prod.ts

# Change to:
apiHost: "http://udagram-api-dev.us-east-1.elasticbeanstalk.com/api/v0"
```

## 📝 For CircleCI

Update `.circleci/config.yml` to use console deployment instead of EB CLI, or note that manual deployment is required due to AWS Academy restrictions.

## 🆘 Troubleshooting

### Environment Shows "Degraded" or "Severe"

**Check CloudWatch Logs:**
1. EB Console → Logs → Request Logs → Last 100 Lines
2. Look for errors

**Common Issues:**
- Environment variables not set
- Wrong Node.js version
- Database connection failed
- Missing dependencies in deployment package

### Health Check Fails

**Verify:**
- Application starts on port 8080 (EB default)
- Environment variables are set correctly
- Database is accessible from EB security group

### Can't Upload Zip File

**Reduce size:**
```bash
# Make sure you're zipping www/ not the entire project
cd www
zip -r ../app.zip .
# Excludes node_modules (already in www build)
```

---

**Try creating the EB environment through AWS Console instead of CLI!** 🌐

This bypasses the CLI permission restrictions.

