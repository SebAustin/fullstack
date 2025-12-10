# 🚀 Deployment Next Steps

## ✅ What's Complete

- ✅ Infrastructure deployed via Terraform (RDS, S3, Security Groups)
- ✅ Frontend built and ready
- ✅ Backend API built (`www/Archive.zip`)
- ✅ EB environment created: `udagram-api-dev`
- ✅ EB deployment successful
- ✅ Environment health: **Green**

## ⚠️ What Needs to Be Done

Your API is deployed but returns **502 Bad Gateway** because:

1. ❌ **Environment variables not set** → API can't connect to database
2. ❌ **RDS security group not configured** → Database blocks EB connections

## 🎯 Action Plan

Follow these steps **in order**:

### Step 1: Configure RDS Security Group ⭐ CRITICAL

**Why:** Allow EB environment to connect to RDS database

**Guide:** `CONFIGURE_RDS_SECURITY_GROUP.md`

**Quick Steps:**
1. AWS Console → EC2 → Instances
2. Find instance with "udagram-api-dev"
3. Copy its security group ID (e.g., `sg-xxxxx`)
4. Go to: EC2 → Security Groups → `sg-0eaaac15ce2ced731`
5. Edit inbound rules → Add rule:
   - Type: PostgreSQL
   - Port: 5432
   - Source: [EB security group ID from step 3]
6. Save rules

### Step 2: Set Environment Variables ⭐ CRITICAL

**Why:** Provide database credentials and configuration to your API

**Guide:** `SET_EB_ENV_VARS.md`

**Quick Steps:**
1. AWS Console → Elastic Beanstalk → udagram-api-dev
2. Configuration → Software → Edit
3. Add these environment properties:

```
POSTGRES_HOST=udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=YourSecurePassword123!
POSTGRES_DB=postgres
AWS_BUCKET=udagram-media-d5acd6ba
AWS_REGION=us-east-1
JWT_SECRET=8YhALt%YxYHqdvQpfw!N_@7rT?1e#>G%
URL=http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
PORT=8080
```

4. Click Apply
5. Wait 2-3 minutes

### Step 3: Test Your API ✅

**Test endpoint:**
```bash
curl http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0/feed
```

**Expected response:** `[]` (empty JSON array)

**Or use test script:**
```bash
./test-api.sh
```

### Step 4: Update Frontend Configuration

Once API is working, update the frontend to use the EB URL:

**File:** `udagram/udagram-frontend/src/environments/environment.prod.ts`

```typescript
export const environment = {
  production: true,
  appName: "Udagram",
  apiHost: "http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0",
};
```

### Step 5: Deploy Frontend

```bash
cd udagram/udagram-frontend
npm run deploy
```

Or from project root:
```bash
npm run frontend:deploy
```

### Step 6: Test Full Application

**Frontend URL:**
```
http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
```

**Test:**
1. Open frontend URL in browser
2. Try to log in or sign up
3. Upload an image to feed
4. Verify it appears

### Step 7: Take Screenshots 📸

Capture these for your Udacity submission:

**Screenshots folder structure:**
```
screenshots/
├── aws-rds/
│   ├── database-overview.png
│   └── database-connectivity.png
├── aws-eb/
│   ├── environment-dashboard.png
│   ├── environment-health.png
│   └── environment-variables.png
├── aws-s3/
│   ├── frontend-bucket.png
│   ├── frontend-static-hosting.png
│   └── media-bucket.png
├── circleci/
│   ├── pipeline-success.png
│   └── workflow-diagram.png
└── application/
    ├── frontend-homepage.png
    ├── api-response.png
    └── feed-with-images.png
```

---

## 📚 Reference Documents

All guides are in your project root:

1. **`SET_EB_ENV_VARS.md`** - How to set environment variables via console
2. **`CONFIGURE_RDS_SECURITY_GROUP.md`** - How to allow EB → RDS connections
3. **`AWS_ACADEMY_EB_WORKAROUND.md`** - Complete EB console deployment guide
4. **`EB_DEPLOY_CHECKLIST.md`** - Quick deployment checklist
5. **`test-api.sh`** - Automated API testing script

---

## 🎯 Quick Commands Reference

### Test API
```bash
./test-api.sh
```

### Check EB Status
```bash
cd udagram/udagram-api
eb status
```

### View EB Logs
```bash
cd udagram/udagram-api
eb logs | tail -100
```

### Rebuild and Redeploy Backend
```bash
cd udagram/udagram-api
npm run build
eb deploy
```

### Rebuild and Redeploy Frontend
```bash
cd udagram/udagram-frontend
npm run deploy
```

---

## 🐛 Troubleshooting Quick Links

### 502 Bad Gateway
→ See `SET_EB_ENV_VARS.md` - Environment variables missing

### Database Connection Failed
→ See `CONFIGURE_RDS_SECURITY_GROUP.md` - Security group not configured

### EB CLI Permission Denied
→ See `AWS_ACADEMY_EB_WORKAROUND.md` - Use AWS Console instead

### Frontend Can't Reach API
→ Check `environment.prod.ts` has correct EB URL

---

## ✅ Final Verification Checklist

Before marking deployment complete:

### Infrastructure
- [ ] RDS database accessible
- [ ] S3 frontend bucket with static hosting
- [ ] S3 media bucket created
- [ ] Security groups configured correctly

### Backend API
- [ ] EB environment shows Green/Healthy
- [ ] Environment variables set in EB
- [ ] API responds at `/api/v0/feed`
- [ ] No 502 errors
- [ ] Database connection working

### Frontend
- [ ] Built successfully
- [ ] Deployed to S3
- [ ] Accessible via S3 website URL
- [ ] Can communicate with backend API

### CI/CD
- [ ] CircleCI connected to GitHub
- [ ] Environment variables set in CircleCI
- [ ] Pipeline configuration valid
- [ ] Build job passes

### Documentation
- [ ] README updated with deployment URLs
- [ ] Screenshots captured
- [ ] AWS Academy limitations documented
- [ ] Architecture diagrams complete

---

## 🎉 Current Status

**Your Environment:**
```
Frontend:  http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
Backend:   http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com
Database:  udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
Region:    us-east-1
Status:    ⚠️ Needs configuration (Steps 1 & 2 above)
```

---

## 🚀 Get Started Now!

1. **Open AWS Console** → https://console.aws.amazon.com
2. **Complete Step 1:** Configure RDS security group
3. **Complete Step 2:** Set environment variables  
4. **Run:** `./test-api.sh`
5. **Celebrate!** 🎉

---

**You're almost there! Just 2 configuration steps away from a fully functional deployment!** 💪

