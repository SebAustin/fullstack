# Screenshot Guide for Project Submission

This guide will help you capture all required screenshots for your Udacity project submission.

## 📋 Required Screenshots Checklist

- [ ] AWS RDS Database (showing healthy status)
- [ ] AWS Elastic Beanstalk Environment (showing healthy status)
- [ ] AWS S3 Buckets (frontend and media)
- [ ] CircleCI Last Successful Build
- [ ] CircleCI Environment Variables (with sensitive values hidden)

---

## 🗄️ 1. AWS RDS Database Screenshot

### What to Capture
Your PostgreSQL database showing it's in an **Available** state.

### Steps

1. **Navigate to RDS Console**
   - Go to: https://console.aws.amazon.com/rds
   - Or: AWS Console → Services → RDS

2. **Select Databases**
   - Click on "Databases" in the left sidebar
   - You should see your `udagram-database-XXXXXXXX` instance

3. **Take Screenshot**
   - **Must show**:
     - Database identifier: `udagram-database-XXXXXXXX`
     - Status: **Available** (green)
     - Engine: PostgreSQL 14.15
     - Size: db.t3.micro
     - Region: us-east-1
   - **Can hide**:
     - Endpoint (you can blur/cover it)
     - Any AWS account numbers

4. **Save Screenshot**
   - Save as: `screenshots/aws-rds/rds-database-overview.png`

### Alternative View: Database Details

You can also capture the database details page:
- Click on your database name
- Take a screenshot showing:
  - Status: Available
  - Endpoint & port
  - Configuration details
  - Monitoring tab (optional)

---

## ⚙️ 2. AWS Elastic Beanstalk Screenshot

### What to Capture
Your EB environment showing **Ok** health status.

### Steps

1. **Navigate to Elastic Beanstalk Console**
   - Go to: https://console.aws.amazon.com/elasticbeanstalk
   - Or: AWS Console → Services → Elastic Beanstalk

2. **Select Your Application**
   - You should see `udagram-api` application
   - Click on the application name

3. **View Environment**
   - You should see `udagram-api-dev` environment
   - **Must show**:
     - Environment name: `udagram-api-dev`
     - Health: **Ok** (green) or **Degraded** (yellow - acceptable if you explain why)
     - Environment URL
     - Platform: Node.js 18 running on 64bit Amazon Linux 2023
     - Running version

4. **Take Screenshot**
   - Capture the main environment dashboard
   - Save as: `screenshots/aws-eb/eb-environment-dashboard.png`

### Additional Screenshots (Optional but Recommended)

**Configuration Screenshot:**
- Click "Configuration" tab
- Show environment properties (blur sensitive values)
- Save as: `screenshots/aws-eb/eb-configuration.png`

**Health Screenshot:**
- Click "Health" tab
- Show health status details
- Save as: `screenshots/aws-eb/eb-health-details.png`

**Monitoring Screenshot:**
- Click "Monitoring" tab
- Show some metrics (requests, CPU, etc.)
- Save as: `screenshots/aws-eb/eb-monitoring.png`

---

## 🪣 3. AWS S3 Buckets Screenshots

### What to Capture
Both S3 buckets showing they exist and are configured.

### Steps

1. **Navigate to S3 Console**
   - Go to: https://s3.console.aws.amazon.com/s3
   - Or: AWS Console → Services → S3

2. **Buckets Overview**
   - Take a screenshot showing both buckets:
     - `udagram-frontend-XXXXXXXX`
     - `udagram-media-XXXXXXXX`
   - Save as: `screenshots/aws-s3/s3-buckets-list.png`

3. **Frontend Bucket Details**
   - Click on `udagram-frontend-XXXXXXXX`
   - Take screenshot showing:
     - Bucket name
     - Objects (www/ folder and files)
   - Save as: `screenshots/aws-s3/s3-frontend-bucket.png`

4. **Frontend Bucket - Static Website Hosting**
   - In the frontend bucket, click "Properties" tab
   - Scroll to "Static website hosting"
   - Take screenshot showing:
     - Static website hosting: Enabled
     - Bucket website endpoint URL
   - Save as: `screenshots/aws-s3/s3-frontend-static-hosting.png`

5. **Media Bucket (Optional)**
   - Click on `udagram-media-XXXXXXXX`
   - Take screenshot showing bucket exists
   - Save as: `screenshots/aws-s3/s3-media-bucket.png`

---

## 🔄 4. CircleCI Build Screenshot

### What to Capture
Your latest successful build showing the pipeline completed.

### Steps

1. **Navigate to CircleCI**
   - Go to: https://app.circleci.com/pipelines/github/SebAustin/fullstack
   - Or: CircleCI Dashboard → Your project

2. **Find Latest Build**
   - You should see a list of pipeline runs
   - Find the most recent **successful** build (green checkmark)

3. **Take Screenshot - Pipeline Overview**
   - Click on the successful build
   - Take screenshot showing:
     - **Must show**:
       - Repository name: `SebAustin/fullstack`
       - Branch: `main`
       - Build number/ID
       - Status: **Success** (green checkmark)
       - All jobs: build, hold, deploy (if approved)
       - Timestamp of the build
   - **Can hide**:
     - Nothing needs to be hidden here
   - Save as: `screenshots/circleci/last-successful-build.png`

4. **Take Screenshot - Build Job Details**
   - Click on the "build" job
   - Show all steps completed successfully:
     - Checkout code
     - Install dependencies
     - Lint
     - Build frontend
     - Build backend
   - Save as: `screenshots/circleci/build-job-details.png`

5. **Take Screenshot - Deploy Job (if approved)**
   - If you approved the hold step, click on "deploy" job
   - Show deployment steps
   - Save as: `screenshots/circleci/deploy-job-details.png`

---

## 🔐 5. CircleCI Environment Variables Screenshot

### What to Capture
Your CircleCI environment variables showing they are configured (with values hidden).

### Steps

1. **Navigate to Project Settings**
   - Go to: CircleCI → Projects → SebAustin/fullstack
   - Click the "Project Settings" button (gear icon)

2. **Go to Environment Variables**
   - In the left sidebar, click "Environment Variables"

3. **Take Screenshot**
   - **Must show**:
     - List of all environment variables (names only):
       - `AWS_ACCESS_KEY_ID`
       - `AWS_SECRET_ACCESS_KEY`
       - `AWS_DEFAULT_REGION`
       - `AWS_REGION`
       - `AWS_BUCKET`
       - `POSTGRES_USERNAME`
       - `POSTGRES_PASSWORD`
       - `POSTGRES_HOST`
       - `POSTGRES_DB`
       - `JWT_SECRET`
       - `URL`
   - **Values are automatically hidden** by CircleCI (shown as `********`)
   - Save as: `screenshots/circleci/environment-variables.png`

---

## 📁 Screenshot Directory Structure

After taking all screenshots, your directory should look like this:

```
screenshots/
├── aws-rds/
│   ├── rds-database-overview.png ✅ REQUIRED
│   └── rds-database-details.png (optional)
├── aws-eb/
│   ├── eb-environment-dashboard.png ✅ REQUIRED
│   ├── eb-configuration.png (optional)
│   ├── eb-health-details.png (optional)
│   └── eb-monitoring.png (optional)
├── aws-s3/
│   ├── s3-buckets-list.png ✅ REQUIRED
│   ├── s3-frontend-bucket.png ✅ REQUIRED
│   ├── s3-frontend-static-hosting.png ✅ REQUIRED
│   └── s3-media-bucket.png (optional)
└── circleci/
    ├── last-successful-build.png ✅ REQUIRED
    ├── build-job-details.png ✅ REQUIRED
    ├── deploy-job-details.png (optional)
    └── environment-variables.png ✅ REQUIRED
```

---

## ✅ Screenshot Quality Requirements

### Do's ✅
- **Use full-screen screenshots** (no distractions)
- **Show browser address bar** (proves it's real AWS/CircleCI)
- **Ensure text is readable** (no tiny fonts)
- **Show dates/timestamps** (proves recent deployment)
- **Include environment names** (must be visible)
- **Save as PNG or JPG** (high quality)

### Don'ts ❌
- Don't crop too much (context is important)
- Don't use low resolution (must be readable)
- Don't hide critical information like:
  - Environment names
  - Health statuses
  - Build statuses
  - Timestamps
- Don't include unrelated browser tabs (keep it professional)

---

## 🎯 Quick Screenshot Checklist

Before submitting, verify you have:

| Screenshot | Filename | Must Show |
|------------|----------|-----------|
| RDS Database | `screenshots/aws-rds/rds-database-overview.png` | Database name, Status: Available |
| EB Environment | `screenshots/aws-eb/eb-environment-dashboard.png` | Environment name, Health: Ok/Degraded |
| S3 Buckets List | `screenshots/aws-s3/s3-buckets-list.png` | Both bucket names visible |
| S3 Frontend Bucket | `screenshots/aws-s3/s3-frontend-bucket.png` | Bucket contents, www/ folder |
| S3 Static Hosting | `screenshots/aws-s3/s3-frontend-static-hosting.png` | Static hosting enabled, website URL |
| CircleCI Build | `screenshots/circleci/last-successful-build.png` | Build status: Success, all jobs green |
| CircleCI Build Details | `screenshots/circleci/build-job-details.png` | All build steps completed |
| CircleCI Env Vars | `screenshots/circleci/environment-variables.png` | All required variables listed |

---

## 🖼️ Example Screenshot Layout

### Good Screenshot Example:

```
┌────────────────────────────────────────────────────────┐
│ https://console.aws.amazon.com/rds                     │ ← Address bar visible
├────────────────────────────────────────────────────────┤
│ AWS RDS > Databases                                    │
│                                                         │
│ Database: udagram-database-d5acd6ba                    │ ← Clear name
│ Status: ⚫ Available                                   │ ← Status visible
│ Engine: PostgreSQL 14.15                               │
│ Size: db.t3.micro                                      │
│ Region: us-east-1                                      │
│                                                         │
│ [Endpoint: ████████████████████]                      │ ← Can blur sensitive data
└────────────────────────────────────────────────────────┘
```

---

## 💡 Tips for Taking Screenshots

### macOS
- **Full Screen**: `Cmd + Shift + 3`
- **Selection**: `Cmd + Shift + 4`
- **Window**: `Cmd + Shift + 4` then press `Space`

### Windows
- **Full Screen**: `Windows + Print Screen`
- **Selection**: `Windows + Shift + S`
- **Snipping Tool**: Search for "Snipping Tool"

### Linux
- **GNOME**: `PrtScn` or `Shift + PrtScn`
- **KDE**: `Spectacle` utility
- **Any**: `gnome-screenshot` or `flameshot`

---

## 🚀 After Taking Screenshots

1. **Review each screenshot**:
   - Is it clear and readable?
   - Does it show all required information?
   - Are sensitive values properly covered?

2. **Add screenshots to Git**:
   ```bash
   git add screenshots/
   git commit -m "Add project screenshots for submission"
   git push origin main
   ```

3. **Update README** (if needed):
   - Verify screenshot paths in README.md are correct
   - Ensure all images are referenced properly

4. **Test screenshot links**:
   - View your README on GitHub
   - Verify all screenshots display correctly

---

## ✨ You're Ready to Submit!

Once you have all required screenshots:
- ✅ AWS services screenshots (RDS, EB, S3)
- ✅ CircleCI build screenshots
- ✅ CircleCI environment variables screenshot
- ✅ All screenshots committed to Git
- ✅ README contains working frontend URL
- ✅ Documentation folder has all 3 required docs

**Congratulations! Your project is ready for submission! 🎉**

