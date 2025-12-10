# ✅ Elastic Beanstalk Deployment Checklist

Use this checklist when deploying via AWS Console (required for AWS Academy).

## 📦 Pre-Deployment

- [ ] Deployment package ready: `udagram/udagram-api/www/Archive.zip` (~20 KB)
- [ ] AWS Console login: https://console.aws.amazon.com
- [ ] Database password from: `terraform/terraform.tfvars`
- [ ] JWT secret from: `terraform output -raw jwt_secret`

## 🚀 Deployment Steps

### 1. Create EB Application

- [ ] Navigate to: **Elastic Beanstalk** in AWS Console
- [ ] Click: **Create application**
- [ ] Application name: `udagram-api`
- [ ] Environment name: `udagram-api-dev`
- [ ] Platform: **Node.js 20 on Amazon Linux 2023**
- [ ] Upload code: Select `www/Archive.zip`
- [ ] Preset: **Single instance**
- [ ] Service role: **LabRole**
- [ ] Instance profile: **LabInstanceProfile**
- [ ] Click: **Submit**
- [ ] Wait: 5-10 minutes for creation

### 2. Configure Environment Variables

- [ ] Go to: Environment → **Configuration** → **Software** → **Edit**
- [ ] Add these Environment properties:

```
POSTGRES_HOST=udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=YourSecurePassword123!
POSTGRES_DB=postgres
AWS_BUCKET=udagram-media-d5acd6ba
AWS_REGION=us-east-1
JWT_SECRET=8YhALt%YxYHqdvQpfw!N_@7rT?1e#>G%
URL=http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
```

- [ ] Click: **Apply**
- [ ] Wait: 2-3 minutes

### 3. Verify Deployment

- [ ] Environment status: **Green (Ok)**
- [ ] Get environment URL (e.g., `udagram-api-dev.us-east-1.elasticbeanstalk.com`)
- [ ] Test in browser: `http://[YOUR-URL]/api/v0/feed`
- [ ] Response: `[]` or feed items

### 4. Update Frontend

- [ ] Copy EB environment URL
- [ ] Edit: `udagram-frontend/src/environments/environment.prod.ts`
- [ ] Update `apiHost`: `http://[YOUR-EB-URL]/api/v0`
- [ ] Rebuild and redeploy frontend

### 5. Take Screenshots

- [ ] EB Environment dashboard (showing Green/Healthy)
- [ ] EB Environment variables configuration
- [ ] Browser showing API response
- [ ] RDS database in console
- [ ] S3 buckets
- [ ] Frontend website

## 🔄 Future Updates

When you make code changes:

- [ ] Run: `cd udagram-api && npm run build`
- [ ] Verify: `ls -lh www/Archive.zip`
- [ ] AWS Console → EB → **Upload and deploy**
- [ ] Version: `v1.0.X` (increment)
- [ ] Upload: `www/Archive.zip`
- [ ] Click: **Deploy**

## 📝 Documentation

- [ ] Read: `AWS_ACADEMY_EB_WORKAROUND.md` (full guide)
- [ ] Read: `docs/EB_Console_Setup.md` (detailed instructions)
- [ ] Update: Project README with EB URL
- [ ] Note: AWS Academy limitations in submission

## ✅ Final Verification

- [ ] Backend API accessible
- [ ] Frontend can call backend
- [ ] Database connected
- [ ] S3 media upload works
- [ ] All screenshots captured
- [ ] Documentation complete

---

**Ready to deploy!** 🚀

Your `Archive.zip` is at: `udagram/udagram-api/www/Archive.zip`

Open AWS Console and follow the checklist above!
