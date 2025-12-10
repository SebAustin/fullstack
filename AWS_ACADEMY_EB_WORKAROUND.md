# AWS Academy Elastic Beanstalk Workaround

## ⚠️ The Problem

AWS Academy's `voclabs` role **restricts ALL Elastic Beanstalk CLI operations**:

```
ERROR: NotAuthorizedError - Operation Denied
User: arn:aws:sts::032396568554:assumed-role/voclabs/user...
is not authorized to perform: elasticbeanstalk:UpdateEnvironment
```

**What's blocked:**
- ❌ `eb init` - Works, but...
- ❌ `eb create` - **Blocked**
- ❌ `eb deploy` - **Blocked**
- ❌ `eb setenv` - **Blocked**
- ❌ Any EB CLI command that modifies environments

## ✅ The Solution: Use AWS Console

All EB operations must be done through the **AWS Web Console**.

---

## 🚀 Quick Deployment Guide

### 1. Prepare Deployment Package

Your package is already built:

```bash
Location: udagram/udagram-api/www/Archive.zip
Size: ~20 KB
Ready to upload: ✅
```

### 2. Open AWS Console

1. Go to: https://console.aws.amazon.com
2. Navigate to: **Elastic Beanstalk**
3. Click: **Create application** (or open existing)

### 3. Create/Update Environment

#### If Creating New Environment:

```
Application Settings:
  - Application name: udagram-api
  - Environment name: udagram-api-dev
  
Platform:
  - Platform: Node.js
  - Branch: Node.js 20 running on 64bit Amazon Linux 2023
  - Version: (use recommended)

Application Code:
  - Upload your code
  - Version label: v1.0.0
  - Local file: Browse → Select www/Archive.zip

Presets:
  - Single instance (free tier eligible)

Service Access:
  - Service role: LabRole
  - Instance profile: LabInstanceProfile
  - Key pair: (optional)

Click: Submit
Wait: 5-10 minutes
```

#### If Updating Existing Environment:

```
1. Go to: Elastic Beanstalk → udagram-api → udagram-api-dev
2. Click: "Upload and deploy" (top right)
3. Version label: v1.0.1 (increment each time)
4. Choose file: www/Archive.zip
5. Click: Deploy
6. Wait: 3-5 minutes
```

### 4. Configure Environment Variables

**After environment is Green/Healthy:**

1. Click on: **udagram-api-dev** environment
2. Left sidebar: **Configuration**
3. Section: **Software** → Click **Edit**
4. Scroll to: **Environment properties**
5. Add these variables:

```bash
POSTGRES_HOST=udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=YourSecurePassword123!
POSTGRES_DB=postgres
AWS_BUCKET=udagram-media-d5acd6ba
AWS_REGION=us-east-1
JWT_SECRET=8YhALt%YxYHqdvQpfw!N_@7rT?1e#>G%
URL=http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
```

6. Click: **Apply**
7. Wait: 2-3 minutes for update

### 5. Test Your API

Find your environment URL:
- Example: `udagram-api-dev.us-east-1.elasticbeanstalk.com`

Test in browser:
```
http://udagram-api-dev.us-east-1.elasticbeanstalk.com/api/v0/feed
```

Should return: `[]` or feed items

---

## 🔄 Updating Your Application

When you make code changes:

### Step 1: Build Locally

```bash
cd udagram/udagram-api

# Make sure you're on Node 16
nvm use 16

# Install dependencies (if needed)
npm install

# Build application
npm run build

# Verify Archive.zip was created
ls -lh www/Archive.zip
```

### Step 2: Deploy via Console

1. AWS Console → Elastic Beanstalk → udagram-api
2. Click **"Upload and deploy"**
3. Version: `v1.0.2` (increment each time)
4. File: `www/Archive.zip`
5. Click **Deploy**

---

## 📝 CircleCI Considerations

The `.circleci/config.yml` includes EB deployment, but it will **fail in AWS Academy**.

**Current config has been updated to:**
- Use Node 16.20 (compatible with dependencies)
- Include error handling for EB deployment failure
- Note AWS Academy limitation in comments

**For AWS Academy projects:**
- CircleCI can still build and test
- Frontend deployment to S3 will work
- Backend EB deployment requires manual console upload

**Workflow:**
1. ✅ CircleCI builds and tests code
2. ✅ CircleCI deploys frontend to S3
3. ⚠️ CircleCI attempts EB deploy (will fail in AWS Academy)
4. 🔧 Manually upload to EB via console

---

## 🐛 Troubleshooting

### Environment Shows "Degraded"

**Check Logs:**
1. EB Console → Environment → Logs
2. Request Logs → Last 100 Lines
3. Look for errors

**Common Causes:**
- Missing environment variables
- Database connection failed
- Application not listening on port 8080
- Start script incorrect

### 502 Bad Gateway

**Cause:** Application not starting

**Verify:**
- Environment variables are set correctly
- RDS security group allows EB security group
- Application starts locally with same env vars
- `package.json` start script is correct: `"start": "node ./www/server.js"`

### Application Won't Start

**Check:**
```bash
# Verify Archive.zip structure
unzip -l www/Archive.zip | head -20

# Should contain:
# - server.js (main entry point)
# - config/ directory
# - controllers/ directory
# - package.json
```

**Verify start command in package.json:**
```json
{
  "scripts": {
    "start": "node ./www/server.js"
  }
}
```

### Can't Upload Zip File

**Size too large:**
```bash
# Check size
ls -lh www/Archive.zip

# If > 512 MB, reduce:
cd www
rm -rf node_modules  # Should not be in www/
zip -r ../Archive.zip .
```

**EB rejects file:**
- Ensure zip is created from www/ directory
- File should contain server.js at root level
- Don't zip the www/ folder itself

---

## 📸 Screenshots for Udacity Submission

### What to Screenshot:

1. **EB Environment Dashboard**
   - Shows Green/Healthy status
   - Environment URL visible

2. **EB Configuration - Environment Variables**
   - Shows all environment properties set

3. **EB Application Versions**
   - Shows deployed versions

4. **API Response**
   - Browser showing `/api/v0/feed` endpoint working

5. **RDS Database**
   - RDS Console showing database running

6. **S3 Buckets**
   - Frontend bucket with static website hosting
   - Media bucket configured

7. **CircleCI Pipeline**
   - Build passing
   - Workflow diagram

### Optional Documentation:

Create a `docs/AWS_ACADEMY_NOTE.md` explaining:
- AWS Academy EB CLI restrictions encountered
- Workaround using AWS Console
- All infrastructure successfully deployed
- Application fully functional despite limitations

---

## ✅ Verification Checklist

Before marking deployment complete:

- [ ] RDS database created and accessible
- [ ] S3 frontend bucket with static hosting enabled
- [ ] S3 media bucket created
- [ ] EB environment created and showing Green/Healthy
- [ ] Environment variables configured in EB
- [ ] API responds at `/api/v0/feed` endpoint
- [ ] Frontend deployed and accessible
- [ ] Frontend can communicate with backend API
- [ ] CircleCI configured (even if EB step fails)
- [ ] All infrastructure documented
- [ ] Screenshots captured for submission

---

## 🎯 Summary

**What Works:**
- ✅ Terraform infrastructure deployment
- ✅ RDS PostgreSQL database
- ✅ S3 buckets and static hosting
- ✅ EB environment creation (via Console)
- ✅ EB deployments (via Console)
- ✅ Frontend deployment (CircleCI + S3)
- ✅ Security groups and networking

**What Doesn't Work in AWS Academy:**
- ❌ EB CLI commands (create, deploy, setenv)
- ❌ IAM user creation (handled with session credentials)
- ❌ IAM role tagging

**Workaround:**
- Use AWS Console for all EB operations
- Use AWS Academy session credentials for CLI
- Document limitations in project README

---

**Your deployment is ready to go via AWS Console!** 🚀

The Archive.zip is built and ready at: `udagram/udagram-api/www/Archive.zip`

Just upload it through the AWS Console following the steps above!

