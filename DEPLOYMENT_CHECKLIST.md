# Deployment Checklist - Udagram Project

## ✅ Completed Setup

All configuration files and documentation have been created. Here's what's ready:

### Configuration Files Created

- ✅ `.gitignore` - Prevents committing sensitive files and dependencies
- ✅ `.circleci/config.yml` - Complete CI/CD pipeline configuration
- ✅ Updated `udagram-api/package.json` - Fixed deployment scripts
- ✅ Updated `environment.prod.ts` - Placeholder for production API URL
- ✅ Updated `bin/deploy.sh` - Environment-based S3 deployment script

### Documentation Created

- ✅ `docs/Infrastructure_description.md` - Complete AWS infrastructure documentation with architecture diagrams
- ✅ `docs/Pipeline_description.md` - Detailed CI/CD pipeline documentation with workflow diagrams
- ✅ `docs/Application_dependencies.md` - Comprehensive dependencies list
- ✅ `docs/AWS_setup_guide.md` - Step-by-step AWS setup instructions
- ✅ `README.md` - Updated with complete project information

### Folders Created

- ✅ `docs/` - Documentation folder
- ✅ `screenshots/` - Screenshots folder with subdirectories (circleci, aws-rds, aws-eb, aws-s3, application)

## 🚀 Next Steps - Action Required

To complete the deployment, follow these steps:

### Option A: Automated AWS Setup with Terraform (Recommended) 🌟

**Use Terraform to automatically create all AWS resources in ~10 minutes!**

```bash
cd terraform

# Quick start (3 commands)
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit: Change db_password!
./deploy.sh

# That's it! 🎉
```

**What Terraform creates for you:**
- ✅ RDS PostgreSQL Database
- ✅ S3 Buckets (frontend + media)
- ✅ IAM User with credentials
- ✅ Security Groups
- ✅ All necessary configurations

**See:** [`terraform/QUICKSTART.md`](terraform/QUICKSTART.md) for detailed instructions.

After Terraform completes, skip to **Step 2.2: Create Elastic Beanstalk Environment** below.

---

### Option B: Manual AWS Setup

If you prefer manual setup, follow the detailed guide in [`docs/AWS_setup_guide.md`](docs/AWS_setup_guide.md).

---

### 1. Create GitHub Repository

```bash
cd "/Users/shenry/Documents/Personal/Training/Project/Udacity/Full Stack JavaScript Developper/Hosting a Full Stack Application/nd0067-c4-deployment-process-project-starter-master"

# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Udagram deployment setup"

# Add remote repository (create repo on GitHub first)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Push to GitHub
git push -u origin main
```

**Steps on GitHub:**
1. Go to [github.com](https://github.com) and log in
2. Click "New repository"
3. Name it (e.g., `udagram-deployment`)
4. Don't initialize with README (we already have one)
5. Copy the repository URL
6. Use it in the commands above

### 2. Set Up AWS Resources

Follow the detailed guide: [`docs/AWS_setup_guide.md`](docs/AWS_setup_guide.md)

**Quick checklist:**

- [ ] Create RDS PostgreSQL database
  - Instance: db.t3.micro (free tier)
  - Public access: Yes
  - Save endpoint, username, password
  - Configure security group (port 5432)

- [ ] Create S3 bucket for frontend
  - Enable static website hosting
  - Configure bucket policy (public read)
  - Configure CORS
  - Save bucket website URL

- [ ] Create IAM user for deployment
  - Programmatic access
  - Permissions: S3FullAccess, ElasticBeanstalk policies
  - Save Access Key ID and Secret Access Key

- [ ] Create Elastic Beanstalk environment
  ```bash
  cd udagram/udagram-api
  eb init
  eb create udagram-api-dev --single --instance-types t2.medium
  ```
  - Save environment URL

### 3. Update Configuration with Real Values

**Update these files with your actual AWS values:**

#### `udagram/set_env.sh` (for local development)
```bash
export POSTGRES_USERNAME=postgres
export POSTGRES_PASSWORD=YOUR_ACTUAL_PASSWORD
export POSTGRES_HOST=YOUR_RDS_ENDPOINT
export POSTGRES_DB=postgres
export AWS_BUCKET=YOUR_ACTUAL_BUCKET_NAME
export AWS_REGION=us-east-1
export AWS_PROFILE=default
export JWT_SECRET=YOUR_RANDOM_SECRET_STRING
export URL=http://localhost:8100
```

#### `udagram/udagram-frontend/src/environments/environment.prod.ts`
Replace the placeholder URL:
```typescript
apiHost: "http://udagram-api-dev.eba-YOUR-ACTUAL-ID.us-east-1.elasticbeanstalk.com/api/v0"
```

#### Set Environment Variables in Elastic Beanstalk
Via EB CLI:
```bash
cd udagram/udagram-api
eb setenv \
  POSTGRES_USERNAME=postgres \
  POSTGRES_PASSWORD=YOUR_PASSWORD \
  POSTGRES_HOST=YOUR_RDS_ENDPOINT \
  POSTGRES_DB=postgres \
  AWS_BUCKET=YOUR_BUCKET_NAME \
  AWS_REGION=us-east-1 \
  JWT_SECRET=YOUR_JWT_SECRET \
  URL=YOUR_FRONTEND_URL
```

Or via AWS Console: Elastic Beanstalk > Environment > Configuration > Software

### 4. Set Up CircleCI

1. **Create CircleCI Account**
   - Go to [circleci.com](https://circleci.com)
   - Sign up with GitHub

2. **Connect Your Repository**
   - Click "Set Up Project"
   - Select your repository
   - CircleCI will detect `.circleci/config.yml`

3. **Add Environment Variables**
   
   In CircleCI Project Settings > Environment Variables, add:
   
   | Variable Name | Value |
   |---------------|-------|
   | `AWS_ACCESS_KEY_ID` | Your IAM access key |
   | `AWS_SECRET_ACCESS_KEY` | Your IAM secret key |
   | `AWS_REGION` | us-east-1 (or your region) |
   | `AWS_DEFAULT_REGION` | us-east-1 (same as above) |
   | `AWS_BUCKET` | Your S3 bucket name |
   | `POSTGRES_USERNAME` | postgres |
   | `POSTGRES_PASSWORD` | Your DB password |
   | `POSTGRES_HOST` | Your RDS endpoint |
   | `POSTGRES_DB` | postgres |
   | `JWT_SECRET` | Your JWT secret |
   | `URL` | Your frontend S3 URL |

### 5. Test Locally Before Deploying

**Test Backend:**
```bash
cd udagram/udagram-api
source ../set_env.sh
npm install
npm run dev
```
Visit: http://localhost:8080/api/v0/feed

**Test Frontend:**
```bash
cd udagram/udagram-frontend
npm install -f
ionic serve
```
Visit: http://localhost:8100

### 6. Manual Deployment (First Time)

**Deploy Backend:**
```bash
cd udagram/udagram-api
npm run build
npm run deploy
```

**Deploy Frontend:**
```bash
cd udagram/udagram-frontend
npm run build
npm run deploy
```

### 7. Trigger CircleCI Pipeline

```bash
# Make sure all changes are committed
git add .
git commit -m "Configure deployment with actual AWS values"
git push origin main
```

This will trigger the CircleCI pipeline. You can watch the progress at circleci.com.

### 8. Take Screenshots

After successful deployment, take screenshots for your submission:

**Required screenshots:**
- [ ] CircleCI: Last successful build (showing all jobs)
- [ ] AWS RDS: Database overview and configuration
- [ ] AWS Elastic Beanstalk: Environment dashboard (showing healthy status)
- [ ] AWS S3: Bucket configuration and properties
- [ ] Application: Working frontend application

Save screenshots in the `screenshots/` folder. See `screenshots/README.md` for detailed guidance.

### 9. Update README

Update these sections in `README.md` with your actual values:

- [ ] Replace CircleCI badge URL with your repo
- [ ] Add your actual frontend URL
- [ ] Add your actual backend API URL
- [ ] Add your name and GitHub username at the bottom

### 10. Final Verification

- [ ] Frontend loads successfully from S3 URL
- [ ] Backend API responds at /api/v0/feed
- [ ] Can register a new user
- [ ] Can log in
- [ ] Can upload a photo
- [ ] CircleCI pipeline runs successfully
- [ ] All screenshots captured
- [ ] Documentation complete

## 📚 Documentation Reference

Quick links to documentation:

- **AWS Setup**: [`docs/AWS_setup_guide.md`](docs/AWS_setup_guide.md)
- **Infrastructure Details**: [`docs/Infrastructure_description.md`](docs/Infrastructure_description.md)
- **Pipeline Details**: [`docs/Pipeline_description.md`](docs/Pipeline_description.md)
- **Dependencies**: [`docs/Application_dependencies.md`](docs/Application_dependencies.md)
- **Screenshots Guide**: [`screenshots/README.md`](screenshots/README.md)

## 🔧 Troubleshooting

If you encounter issues, refer to:

1. Troubleshooting section in `README.md`
2. Troubleshooting section in `docs/AWS_setup_guide.md`
3. Check CircleCI build logs
4. Check Elastic Beanstalk logs: `eb logs`
5. Check AWS CloudWatch logs

## ⚠️ Important Security Notes

1. **Never commit these files:**
   - `set_env.sh` (already in .gitignore)
   - Any file containing passwords or access keys
   - `.pem` key pair files

2. **Secure your credentials:**
   - Use strong passwords for RDS
   - Rotate AWS access keys regularly
   - Enable MFA on AWS root account

3. **Production security:**
   - Restrict RDS security group to specific IPs
   - Use HTTPS (configure SSL certificate)
   - Enable CloudTrail logging

## 💰 Cost Management

**Free Tier Resources:**
- RDS: 750 hours/month (db.t3.micro)
- EC2: 750 hours/month (t2.micro via EB)
- S3: 5GB storage
- Data Transfer: 15GB/month

**To minimize costs:**
- Use single instance (not load balanced)
- Stop/terminate when not actively using
- Monitor AWS Billing dashboard
- Set up billing alerts

**Stop resources when not in use:**
```bash
# Terminate EB environment (can recreate)
eb terminate udagram-api-dev

# Stop RDS database (billings continue but reduced)
aws rds stop-db-instance --db-instance-identifier udagram-database
```

## ✨ Project Submission

Before submitting to Udacity:

- [ ] All code is working locally
- [ ] Application deployed successfully to AWS
- [ ] CircleCI pipeline runs successfully
- [ ] All required screenshots captured and organized
- [ ] Documentation complete and accurate
- [ ] README has working deployment URLs
- [ ] No sensitive information in repository

## 🎉 Success Criteria

Your project is complete when:

1. ✅ Frontend accessible via S3 static website URL
2. ✅ Backend API accessible via Elastic Beanstalk URL
3. ✅ Can register, login, and upload photos
4. ✅ CircleCI pipeline builds and deploys on git push
5. ✅ All documentation complete with diagrams
6. ✅ Screenshots captured and organized
7. ✅ Repository clean and well-organized

---

**Need Help?**
- Review the comprehensive documentation in `docs/` folder
- Check the troubleshooting sections
- Review CircleCI and AWS console logs
- Reference the project rubric for requirements

Good luck with your deployment! 🚀

