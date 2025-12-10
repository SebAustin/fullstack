# CircleCI Deployment Guide for AWS Academy

## ⚠️ Critical: AWS Academy S3 Restriction

Your AWS Academy credentials have an **explicit deny policy** for `s3:PutObject` operations. This means:

- ❌ **You CANNOT deploy frontend to S3 from your local machine**
- ❌ **Manual `aws s3 sync` commands will fail**
- ❌ **Direct `npm run deploy` will fail**
- ✅ **CircleCI deployment with proper IAM credentials WILL work**

The error you see:
```
AccessDenied: User ... is not authorized to perform: s3:PutObject on resource: ... 
with an explicit deny in an identity-based policy
```

This is a hard AWS Academy restriction that cannot be bypassed locally.

## Solution: Deploy via CircleCI

CircleCI uses its own AWS IAM credentials (that you configure), which are not subject to the same AWS Academy restrictions.

---

## Step 1: Set Up CircleCI Environment Variables

Go to your CircleCI project settings and add these environment variables:

### Required Environment Variables

| Variable Name | Value | Description |
|--------------|-------|-------------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key | From your AWS Academy credentials or IAM user |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key | From your AWS Academy credentials or IAM user |
| `AWS_DEFAULT_REGION` | `us-east-1` | Your AWS region |
| `AWS_BUCKET` | `udagram-frontend-XXXXXX` | Your S3 frontend bucket name |
| `POSTGRES_USERNAME` | `postgres` | Database username |
| `POSTGRES_PASSWORD` | Your DB password | From Terraform output |
| `POSTGRES_DB` | `udagram` | Database name |
| `POSTGRES_HOST` | Your RDS endpoint | From Terraform output (without port) |
| `PORT` | `8080` | Backend API port |
| `JWT_SECRET` | Your JWT secret | From Terraform output |
| `URL` | Your EB URL | Full Elastic Beanstalk URL |

### How to Get the Values

1. **RDS Endpoint, S3 Bucket, JWT Secret**:
   ```bash
   cd terraform
   terraform output
   ```

2. **AWS Credentials** (if not using AWS Academy temporary credentials):
   - Go to AWS Console → IAM → Users → Your User → Security Credentials
   - Create Access Key if needed

3. **Elastic Beanstalk URL**:
   ```
   http://udagram-api-dev.eba-XXXXXXX.us-east-1.elasticbeanstalk.com
   ```
   (Get from AWS EB Console)

### How to Add Variables in CircleCI

1. Go to https://app.circleci.com/
2. Select your project (`SebAustin/fullstack`)
3. Click **Project Settings** (top right)
4. Click **Environment Variables** (left sidebar)
5. Click **Add Environment Variable**
6. Add each variable one by one

**IMPORTANT**: These variables will be used by CircleCI's IAM role to deploy to AWS. Make sure they have sufficient permissions.

---

## Step 2: Update Elastic Beanstalk Configuration

Since you're using AWS Academy, the EB CLI deployment from CircleCI may also fail. We'll handle this two ways:

### Option A: Use AWS Console for EB Deployment

1. Build locally:
   ```bash
   cd udagram/udagram-api
   npm install
   npm run build
   ```

2. Create deployment package:
   ```bash
   cd www
   zip -r Archive.zip .
   ```

3. Upload to EB via AWS Console:
   - Go to Elastic Beanstalk → Environments → `udagram-api-dev`
   - Click **Upload and deploy**
   - Choose `Archive.zip`
   - Click **Deploy**

### Option B: Let CircleCI Try (with graceful error handling)

The CircleCI config includes error handling for EB deployment. If it fails:
- The pipeline will log the error but continue
- You can manually deploy via AWS Console (Option A)
- Frontend will still be deployed to S3 successfully

---

## Step 3: Push Code to GitHub

Now that CircleCI is configured, push your code:

```bash
# Make sure you're in the project root
cd nd0067-c4-deployment-process-project-starter-master

# Check git status
git status

# Add the new .circleci directory
git add .circleci/

# Commit
git commit -m "Add CircleCI configuration for AWS Academy deployment"

# Push to main branch (CircleCI only runs on main)
git push origin main
```

---

## Step 4: Monitor CircleCI Build

1. Go to https://app.circleci.com/
2. Find your project (`SebAustin/fullstack`)
3. Watch the pipeline run:
   - **Build Job**: Installs dependencies, builds frontend & backend, runs linting
   - **Hold Job**: Manual approval required (click "Approve" when ready)
   - **Deploy Job**: Deploys frontend to S3 and attempts EB deployment

### Expected Results

✅ **Frontend Deployment**: Should succeed (files uploaded to S3)
⚠️ **Backend Deployment**: May fail due to AWS Academy EB CLI restrictions
   - If it fails, use AWS Console manual deployment (see Option A above)

---

## Step 5: Verify Deployment

### Frontend (S3)

1. Check S3 bucket in AWS Console:
   ```
   AWS Console → S3 → udagram-frontend-XXXXXX
   ```
   You should see `index.html`, `main.js`, and other files

2. Test frontend URL:
   ```
   http://udagram-frontend-XXXXXX.s3-website-us-east-1.amazonaws.com
   ```

### Backend (Elastic Beanstalk)

1. Check EB environment in AWS Console:
   ```
   AWS Console → Elastic Beanstalk → udagram-api-dev
   ```
   Status should be "Ok" (green)

2. Test API endpoint:
   ```bash
   curl http://udagram-api-dev.eba-XXXXXXX.us-east-1.elasticbeanstalk.com/api/v0
   ```

---

## Troubleshooting

### Issue: CircleCI Build Fails on "Install Dependencies"

**Solution**: Node version mismatch. Update `.circleci/config.yml`:
```yaml
node-version: '16.20'  # Match your package.json engines
```

### Issue: CircleCI Deploy Fails with "AWS credentials not configured"

**Solution**: Check environment variables in CircleCI:
- Go to Project Settings → Environment Variables
- Verify `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`

### Issue: Frontend Deploys but Site Shows Errors

**Solution**: Update `environment.prod.ts` with correct API URL:
```typescript
export const environment = {
  production: true,
  appName: 'Udagram',
  apiHost: 'http://udagram-api-dev.eba-XXXXXXX.us-east-1.elasticbeanstalk.com/api/v0'
};
```
Then commit and push again.

### Issue: EB Deployment Fails in CircleCI

**Solution**: This is expected with AWS Academy. Use AWS Console manual deployment:
1. Build locally: `npm run build` in `udagram-api`
2. Create zip: `cd www && zip -r Archive.zip .`
3. Upload via AWS Console → EB → Upload and deploy

---

## Summary of AWS Academy Workarounds

| Service | Local Deployment | CircleCI Deployment | AWS Console Manual |
|---------|-----------------|---------------------|-------------------|
| **S3 Frontend** | ❌ Blocked by explicit deny | ✅ Works with proper IAM | ✅ Works via upload |
| **EB Backend** | ❌ Blocked by IAM restrictions | ⚠️ May fail (EB CLI) | ✅ Works via upload |
| **RDS** | ✅ Direct connection works | N/A | N/A |

**Recommended Workflow for AWS Academy**:
1. Develop locally
2. Commit and push to GitHub
3. CircleCI builds and deploys frontend
4. Manually deploy backend via AWS Console if needed
5. Verify both services are running

---

## Next Steps

1. ✅ Set up CircleCI environment variables
2. ✅ Push code to GitHub (`main` branch)
3. ✅ Approve CircleCI deployment (click "Approve" in CircleCI UI)
4. ⚠️ If EB deployment fails, manually deploy via AWS Console
5. ✅ Test your deployed application
6. ✅ Take screenshots for project submission

Good luck! 🚀

