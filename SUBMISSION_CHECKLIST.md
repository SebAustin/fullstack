# Udacity Project Submission Checklist

Use this checklist to ensure your project meets all requirements before submission.

---

## ✅ Required Deliverables Checklist

### 📸 1. Screenshots (REQUIRED)

#### AWS Infrastructure Screenshots

- [ ] **RDS Database Screenshot**
  - Location: `screenshots/aws-rds/rds-database-overview.png`
  - Must show: Database name, Status (Available), Engine (PostgreSQL 14.15)
  - Optional blur: Endpoint details, account numbers

- [ ] **Elastic Beanstalk Screenshot**
  - Location: `screenshots/aws-eb/eb-environment-dashboard.png`
  - Must show: Environment name, Health status (Ok/Degraded), Platform, URL
  - Optional: Configuration, monitoring screenshots

- [ ] **S3 Buckets Screenshots**
  - Location: `screenshots/aws-s3/s3-buckets-list.png`
  - Must show: Both buckets (frontend and media)
  - Location: `screenshots/aws-s3/s3-frontend-bucket.png`
  - Must show: Bucket contents, www/ folder
  - Location: `screenshots/aws-s3/s3-frontend-static-hosting.png`
  - Must show: Static website hosting enabled, website URL

#### CircleCI Screenshots

- [ ] **Latest Build Screenshot**
  - Location: `screenshots/circleci/last-successful-build.png`
  - Must show: Build status (Success), Repository name, Branch (main), Timestamp
  - Must show: All jobs (build, hold, deploy)

- [ ] **Build Job Details**
  - Location: `screenshots/circleci/build-job-details.png`
  - Must show: All build steps completed successfully

- [ ] **Environment Variables Screenshot**
  - Location: `screenshots/circleci/environment-variables.png`
  - Must show: All required environment variables (names only, values hidden)
  - Required variables:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_DEFAULT_REGION
    - AWS_REGION
    - AWS_BUCKET
    - POSTGRES_USERNAME
    - POSTGRES_PASSWORD
    - POSTGRES_HOST
    - POSTGRES_DB
    - JWT_SECRET
    - URL

---

### 📚 2. Documentation (REQUIRED)

#### Three Separate Documentation Files

- [ ] **Application Dependencies** (`docs/Application_dependencies.md`)
  - [x] Lists all major dependencies (Node.js, npm, PostgreSQL, AWS services)
  - [x] Explains what each dependency is used for
  - [x] Includes frontend dependencies (Angular, Ionic)
  - [x] Includes backend dependencies (Express, Sequelize, pg)
  - [x] Includes system dependencies (AWS CLI, EB CLI)

- [ ] **Infrastructure Description** (`docs/Infrastructure_description.md`)
  - [x] Describes all AWS services used (S3, RDS, Elastic Beanstalk)
  - [x] Explains how services connect to each other
  - [x] Includes infrastructure diagram
  - [x] Details configuration for each service

- [ ] **Pipeline Process** (`docs/Pipeline_description.md`)
  - [x] Describes the CI/CD pipeline workflow
  - [x] Lists all pipeline stages (build, hold, deploy)
  - [x] Explains what happens at each stage
  - [x] Includes pipeline diagram
  - [x] Shows Development → GitHub → CircleCI → AWS flow

---

### 📊 3. Diagrams (REQUIRED)

- [ ] **Infrastructure Diagram**
  - Location: `docs/Infrastructure_description.md` (mermaid diagram)
  - Alternative: `docs/DIAGRAMS.md` (ASCII diagram)
  - Must show: AWS S3, AWS RDS, AWS Elastic Beanstalk
  - Must show: Connections between services (arrows)

- [ ] **Pipeline Diagram**
  - Location: `docs/Pipeline_description.md` (mermaid diagram)
  - Alternative: `docs/DIAGRAMS.md` (ASCII diagram)
  - Must show: Development → GitHub → CircleCI → AWS
  - Must show: Build, test, and deployment stages

---

### 🔗 4. README Requirements (REQUIRED)

- [ ] **Working Frontend URL**
  - URL: `http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com`
  - Must be accessible and working
  - Application should load without errors

- [ ] **CircleCI Build Badge**
  - Badge displays in README
  - Shows current build status
  - Links to CircleCI project

- [ ] **Project Overview**
  - Description of what the application does
  - Technology stack listed

- [ ] **Documentation Links**
  - Links to all 3 documentation files
  - Links work when viewing on GitHub

- [ ] **Setup Instructions**
  - How to install dependencies
  - How to run locally
  - How to deploy

---

### ⚙️ 5. AWS Configuration (REQUIRED)

#### Elastic Beanstalk Environment Variables

- [ ] **All environment variables set in EB Console**
  - POSTGRES_HOST
  - POSTGRES_USERNAME
  - POSTGRES_PASSWORD
  - POSTGRES_DB
  - AWS_BUCKET
  - AWS_REGION
  - JWT_SECRET
  - URL
  - PORT (set to 8080)

- [ ] **EB Environment Health**
  - Status: Ok (green) or Degraded (yellow, with explanation)
  - Application accessible via EB URL
  - API endpoints respond correctly

#### RDS Security Group

- [ ] **Security group allows EB connections**
  - Inbound rule: PostgreSQL (port 5432)
  - Source: Elastic Beanstalk security group
  - Database accessible from EB environment

#### S3 Buckets

- [ ] **Frontend bucket configured**
  - Static website hosting enabled
  - Bucket policy allows public read
  - CORS configured (if needed)
  - Index document: index.html

- [ ] **Media bucket configured**
  - Public read access enabled
  - EB can write to bucket (IAM permissions)

---

### 🔄 6. CircleCI Configuration (REQUIRED)

- [ ] **Repository connected to CircleCI**
  - Project shows up in CircleCI dashboard
  - `.circleci/config.yml` detected

- [ ] **Environment variables configured in CircleCI**
  - All 11 required variables set
  - Values are current (AWS Academy credentials refreshed)

- [ ] **Build succeeds**
  - Latest build shows green checkmark
  - All jobs complete successfully
  - No failing tests or linting errors

- [ ] **Deployment tested**
  - Hold job approved (if testing deployment)
  - Deploy job runs successfully
  - Frontend and backend deployed correctly

---

### 🧪 7. Application Testing (RECOMMENDED)

- [ ] **Frontend accessible**
  - URL loads without errors
  - Application UI displays correctly
  - No console errors in browser

- [ ] **Backend API accessible**
  - API URL responds to requests
  - `/api/v0/feed` endpoint returns data (or empty array)
  - No 502/503 errors

- [ ] **Database connectivity**
  - Backend can connect to RDS
  - No connection timeout errors
  - Database queries work

- [ ] **Image upload (optional)**
  - Users can register/login
  - Users can upload images
  - Images stored in S3 media bucket

---

### 📦 8. Code Quality (RECOMMENDED)

- [ ] **No linting errors**
  - Frontend linting passes
  - Backend linting passes
  - CircleCI build succeeds

- [ ] **No sensitive data in Git**
  - `.env` files in `.gitignore`
  - `set_env.sh` in `.gitignore`
  - `terraform.tfvars` in `.gitignore`
  - No AWS credentials in code
  - No database passwords in code

- [ ] **Clean commit history**
  - Meaningful commit messages
  - No unnecessary files committed
  - No large binary files

---

## 🎯 Pre-Submission Verification

### Step 1: Check AWS Services

```bash
# Test RDS connectivity
psql -h udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com -U postgres -d postgres

# Test EB API
curl http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0/feed

# Test S3 frontend
curl http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
```

### Step 2: Verify Screenshots

```bash
# Check screenshots exist
ls -la screenshots/aws-rds/
ls -la screenshots/aws-eb/
ls -la screenshots/aws-s3/
ls -la screenshots/circleci/

# Verify they're not empty files
du -h screenshots/**/*.png
```

### Step 3: Verify Documentation

```bash
# Check documentation files exist
ls -la docs/Application_dependencies.md
ls -la docs/Infrastructure_description.md
ls -la docs/Pipeline_description.md
```

### Step 4: Test GitHub Repository

1. View README on GitHub: https://github.com/SebAustin/fullstack
2. Verify frontend URL link works
3. Verify CircleCI badge shows
4. Verify all screenshots display
5. Verify documentation links work

### Step 5: Final CircleCI Check

1. Go to: https://app.circleci.com/pipelines/github/SebAustin/fullstack
2. Verify latest build is successful (green)
3. Check all jobs completed (build, hold, deploy)
4. Verify no errors in logs

---

## 📋 Reviewer's Checklist (What They'll Look For)

### Infrastructure Setup ✅

- [ ] RDS is created and available
- [ ] Elastic Beanstalk environment is healthy
- [ ] S3 buckets are properly configured
- [ ] Screenshots prove services are working

### CI/CD Pipeline ✅

- [ ] CircleCI is connected to GitHub
- [ ] Latest build is successful
- [ ] Environment variables are configured
- [ ] Pipeline automatically deploys on push

### Documentation ✅

- [ ] Three separate documentation files exist
- [ ] App dependencies clearly listed
- [ ] Infrastructure diagram shows AWS services
- [ ] Pipeline diagram shows CI/CD flow
- [ ] Documentation is clear and comprehensive

### Application ✅

- [ ] Frontend is accessible via provided URL
- [ ] Application loads and works correctly
- [ ] No 404, 502, or 503 errors
- [ ] README contains working URL

---

## ⚠️ Common Issues to Avoid

### Screenshots

❌ **Don't**: Use placeholder screenshots or screenshots from tutorials
✅ **Do**: Take your own screenshots showing your actual AWS resources

❌ **Don't**: Hide critical information (environment names, statuses)
✅ **Do**: Hide only sensitive data (endpoints can be partially blurred)

### Documentation

❌ **Don't**: Copy documentation from other sources
✅ **Do**: Write documentation specific to your setup

❌ **Don't**: Leave placeholder text or TODOs
✅ **Do**: Complete all documentation sections

### URLs

❌ **Don't**: Leave placeholder URLs in README
✅ **Do**: Provide working, accessible URLs

❌ **Don't**: Provide URLs that return errors (502, 503)
✅ **Do**: Verify URLs work before submitting

### CircleCI

❌ **Don't**: Submit with failing builds
✅ **Do**: Ensure latest build is successful

❌ **Don't**: Forget to set environment variables
✅ **Do**: Configure all required environment variables

---

## 🚀 Ready to Submit?

### Final Checklist

- [ ] All AWS services are running and healthy
- [ ] All required screenshots are taken and committed
- [ ] All three documentation files are complete
- [ ] Infrastructure and pipeline diagrams are clear
- [ ] README has working frontend URL
- [ ] CircleCI badge is in README
- [ ] Latest CircleCI build is successful
- [ ] All environment variables are configured
- [ ] Frontend application is accessible
- [ ] Backend API is accessible
- [ ] No sensitive data in Git repository
- [ ] All files are pushed to GitHub

### If You Checked All Boxes Above... 🎉

**Congratulations! Your project is ready for submission!**

---

## 📚 Reference Documents

For detailed instructions, see:

- **[SCREENSHOT_GUIDE.md](SCREENSHOT_GUIDE.md)** - How to take all required screenshots
- **[docs/DIAGRAMS.md](docs/DIAGRAMS.md)** - Infrastructure and pipeline diagrams
- **[DEPLOYMENT_NEXT_STEPS.md](DEPLOYMENT_NEXT_STEPS.md)** - Deployment checklist
- **[SET_EB_ENV_VARS.md](SET_EB_ENV_VARS.md)** - How to set EB environment variables
- **[CONFIGURE_RDS_SECURITY_GROUP.md](CONFIGURE_RDS_SECURITY_GROUP.md)** - Database security setup

---

## 🎯 Submission Tips

1. **Double-check everything** before submitting
2. **Test all URLs** to ensure they work
3. **View your GitHub repo** as if you're the reviewer
4. **Verify all images display** in the README
5. **Make sure documentation is readable** and well-formatted

---

## 🆘 Need Help?

If you're stuck on any requirement:

1. Review the specific guide for that requirement
2. Check the rubric carefully
3. Look at the error messages in CircleCI/AWS
4. Verify environment variables are correct
5. Ensure all services are in the correct region (us-east-1)

---

**Good luck with your submission! 🎓**

