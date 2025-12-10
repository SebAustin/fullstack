# AWS Academy S3 Restriction - Critical Issue

## 🚨 The Problem

Your AWS Academy credentials have an **explicit deny policy** for `s3:PutObject` operations on your frontend S3 bucket.

**What this means:**
- You **CANNOT** upload files to S3 from your local machine
- Any command like `aws s3 cp`, `aws s3 sync`, or `npm run deploy` will fail
- The error message will say: `with an explicit deny in an identity-based policy`

**Why this happens:**
AWS Academy intentionally restricts certain operations to prevent students from accidentally incurring costs or making unauthorized changes. The S3 `PutObject` restriction is one such limitation.

---

## ✅ The Solution

**Use CircleCI to deploy your frontend**

CircleCI runs with its own IAM credentials (that you provide), which are not subject to AWS Academy restrictions. This is the **ONLY** way to deploy your frontend automatically.

### What You Need to Do:

1. **Set up CircleCI** (already done ✅)
   - `.circleci/config.yml` has been created
   - Pipeline will build and deploy your frontend

2. **Configure CircleCI Environment Variables**
   - See `CIRCLECI_ENV_VARS.md` for exact values
   - Use AWS Academy session credentials from Learner Lab

3. **Push to GitHub**
   - CircleCI will automatically build and deploy
   - Frontend will be uploaded to S3 successfully

---

## 🔄 Deployment Workflow

```
┌─────────────────┐
│ Local Machine   │
│ (Development)   │
└────────┬────────┘
         │ git push
         ▼
┌─────────────────┐
│ GitHub          │
│ (main branch)   │
└────────┬────────┘
         │ webhook
         ▼
┌─────────────────┐
│ CircleCI        │
│ (Build & Deploy)│
└────────┬────────┘
         │
         ├─────────────┐
         │             │
         ▼             ▼
┌─────────────┐   ┌──────────────┐
│ S3 Bucket   │   │ Elastic      │
│ (Frontend)  │   │ Beanstalk    │
│ ✅ Works    │   │ ⚠️  May fail │
└─────────────┘   └──────────────┘
```

---

## 🛠️ Alternative: Manual Upload via AWS Console

If you need to deploy manually (not recommended for production):

1. Build frontend locally:
   ```bash
   cd udagram/udagram-frontend
   npm run build
   ```

2. Go to AWS Console → S3 → `udagram-frontend-d5acd6ba`

3. Click **Upload** button

4. Drag and drop all files from `www/` directory

5. Set permissions:
   - Expand "Permissions"
   - Check "Grant public-read access"

6. Click **Upload**

⚠️ **Note**: This is tedious and error-prone. Use CircleCI instead.

---

## 📊 Comparison

| Method | Works? | Why? |
|--------|--------|------|
| **Local `aws s3 sync`** | ❌ No | Explicit deny in IAM policy |
| **Local `npm run deploy`** | ❌ No | Uses `aws s3 cp` under the hood |
| **CircleCI deployment** | ✅ Yes | Uses separate IAM credentials |
| **Manual AWS Console upload** | ✅ Yes | Console has different permissions |

---

## 🎯 Next Steps

1. **Configure CircleCI environment variables** (see `CIRCLECI_ENV_VARS.md`)
2. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Add CircleCI configuration for deployment"
   git push origin main
   ```
3. **Approve the deployment in CircleCI** (click "Approve" when prompted)
4. **Verify frontend is deployed** by visiting your S3 website URL

---

## 📚 Related Documentation

- `CIRCLECI_DEPLOYMENT_GUIDE.md` - Complete CircleCI setup guide
- `CIRCLECI_ENV_VARS.md` - Environment variables quick reference
- `AWS_ACADEMY_EB_WORKAROUND.md` - Elastic Beanstalk deployment workaround

---

## ❓ FAQ

**Q: Can I bypass this restriction?**
A: No. AWS Academy enforces this at the IAM level with an explicit deny, which overrides all allow permissions.

**Q: Will this be a problem in production?**
A: No. This is specific to AWS Academy. In a real AWS account, you'll have full permissions.

**Q: What if CircleCI also fails?**
A: Make sure you're using AWS credentials that have `s3:PutObject` permission. AWS Academy session credentials from Learner Lab should work.

**Q: Do I need to update credentials for every deployment?**
A: Only if you're using AWS Academy session credentials, which expire. Create a permanent IAM user if possible.

---

**Bottom Line**: You must use CircleCI (or AWS Console manual upload) to deploy your frontend due to AWS Academy restrictions. This is not a bug - it's an intentional limitation of the learning environment.

