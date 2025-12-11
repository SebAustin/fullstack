# S3 Buckets Explained - Udagram Application

## 🗂️ Two Different S3 Buckets with Different Purposes

Your Udagram application uses **two separate S3 buckets**, each with a specific role:

---

## 1️⃣ Frontend Bucket: `udagram-frontend-d5acd6ba`

### Purpose
Hosts the **static website** (Angular/Ionic frontend application)

### Contains
- Compiled Angular application files
- HTML, CSS, JavaScript bundles
- Images, fonts, SVG icons
- Total: **903 files** after build

### Configuration
- **Website hosting**: Enabled
- **Public access**: Allowed (for public website)
- **Bucket policy**: Allows public read (`s3:GetObject`)
- **Index document**: `index.html`
- **Error document**: `index.html` (for SPA routing)

### Deployment
- **Deployed by**: CircleCI (on every push to `main` branch)
- **Source**: `udagram/udagram-frontend/www/` directory (after `npm run build`)
- **Script**: `udagram/udagram-frontend/bin/deploy.sh`
- **CircleCI variable**: `AWS_BUCKET=udagram-frontend-d5acd6ba`

### Access
- **Website URL**: http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
- **Users**: Anyone can access (public website)

---

## 2️⃣ Media Bucket: `udagram-media-d5acd6ba`

### Purpose
Stores **user-uploaded media files** (photos, images)

### Contains
- User profile pictures
- Post images
- Feed photos
- **Initially empty** (gets populated as users upload content)

### Configuration
- **Website hosting**: Not enabled
- **Public access**: Allowed (via bucket policy for user-uploaded content)
- **Bucket policy**: Allows public read for uploaded images
- **CORS**: Configured to allow uploads from frontend

### Deployment
- **Deployed by**: Not deployed (managed by the application)
- **Populated by**: Backend API when users upload photos
- **Used by**: Backend Node.js application (`udagram-api`)

### Backend Configuration
The backend API uses this bucket via environment variable:

**Elastic Beanstalk Environment Variables**:
```bash
AWS_BUCKET=udagram-media-d5acd6ba  # ← Media bucket
AWS_REGION=us-east-1
```

**Backend Code** (`src/config/config.ts`):
```typescript
aws_media_bucket: process.env.AWS_BUCKET,  // Points to media bucket
```

### Access
- **API**: Backend uploads/retrieves files programmatically
- **Users**: Can view uploaded images via public URLs
- **Direct access**: https://udagram-media-d5acd6ba.s3.amazonaws.com/[image-key]

---

## 📋 Configuration Summary

| Aspect | Frontend Bucket | Media Bucket |
|--------|----------------|--------------|
| **Name** | `udagram-frontend-d5acd6ba` | `udagram-media-d5acd6ba` |
| **Purpose** | Static website hosting | User media storage |
| **Initial State** | Populated with app files | Empty |
| **Website Hosting** | Enabled | Disabled |
| **Deployed By** | CircleCI | Not deployed |
| **Populated By** | Build script | Backend API |
| **Public Access** | Yes (website) | Yes (uploaded images) |
| **CircleCI Env Var** | `AWS_BUCKET=udagram-frontend-d5acd6ba` | Not used in CircleCI |
| **Backend Env Var** | Not used | `AWS_BUCKET=udagram-media-d5acd6ba` |

---

## ⚙️ Environment Variable Configuration

### CircleCI (for frontend deployment)
Set in: **CircleCI Project Settings → Environment Variables**

```bash
AWS_BUCKET=udagram-frontend-d5acd6ba  # ← Frontend bucket for deployment
AWS_ACCESS_KEY_ID=[your-access-key]
AWS_SECRET_ACCESS_KEY=[your-secret-key]
AWS_DEFAULT_REGION=us-east-1
```

### Elastic Beanstalk (for backend API)
Set in: **AWS Console → Elastic Beanstalk → Configuration → Software → Environment Properties**

```bash
AWS_BUCKET=udagram-media-d5acd6ba  # ← Media bucket for uploads
AWS_REGION=us-east-1
POSTGRES_HOST=[your-rds-endpoint]
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=[your-db-password]
POSTGRES_DB=postgres
JWT_SECRET=[your-jwt-secret]
URL=http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com
```

### Local Development (set_env.sh)
For testing locally:

```bash
export AWS_BUCKET=udagram-media-d5acd6ba  # ← Media bucket for backend
export AWS_REGION=us-east-1
export POSTGRES_HOST=udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
export POSTGRES_DB=postgres
export POSTGRES_USERNAME=postgres
export POSTGRES_PASSWORD=[your-password]
export JWT_SECRET=8YhALt%YxYHqdvQpfw!N_@7rT?1e#>G%
export URL=http://localhost:8080
```

---

## 🔄 Data Flow

### Frontend Deployment
```
Developer pushes code
    ↓
GitHub webhook triggers CircleCI
    ↓
CircleCI builds frontend (npm run build)
    ↓
CircleCI runs deploy.sh
    ↓
deploy.sh uploads www/ to AWS_BUCKET (frontend bucket)
    ↓
Users access website at S3 website URL
```

### User Image Upload
```
User uploads photo via frontend
    ↓
Frontend sends image to backend API
    ↓
Backend API receives image
    ↓
Backend uses AWS SDK to upload to AWS_BUCKET (media bucket)
    ↓
Backend returns image URL to frontend
    ↓
Frontend displays image (publicly accessible)
```

---

## ✅ Current Status

After cleanup:

| Bucket | Status | File Count | Purpose |
|--------|--------|------------|---------|
| **udagram-frontend-d5acd6ba** | ✅ Correct | 903 files | Website hosting |
| **udagram-media-d5acd6ba** | ✅ Correct | 0 files | User uploads (initially empty) |

---

## 🐛 Common Mistakes to Avoid

### ❌ Wrong Configuration
```bash
# DON'T set media bucket in CircleCI!
AWS_BUCKET=udagram-media-d5acd6ba  # ← This would deploy frontend to media bucket
```

### ✅ Correct Configuration
```bash
# CircleCI (for frontend deployment)
AWS_BUCKET=udagram-frontend-d5acd6ba  # ← Correct!

# Elastic Beanstalk (for backend uploads)
AWS_BUCKET=udagram-media-d5acd6ba  # ← Correct!
```

---

## 📚 Related Documentation

- `CIRCLECI_ENV_VARS.md` - CircleCI environment variable reference
- `SET_EB_ENV_VARS.md` - Elastic Beanstalk configuration guide
- `terraform/outputs.tf` - Terraform outputs for bucket names
- `udagram/udagram-api/src/config/config.ts` - Backend configuration

---

## 🆘 Troubleshooting

### Problem: Media bucket has frontend files
**Cause**: CircleCI `AWS_BUCKET` was set to media bucket instead of frontend bucket

**Solution**:
```bash
# 1. Clean media bucket
aws s3 rm s3://udagram-media-d5acd6ba/ --recursive

# 2. Verify CircleCI AWS_BUCKET is correct
# Go to CircleCI → Project Settings → Environment Variables
# AWS_BUCKET should be: udagram-frontend-d5acd6ba

# 3. Re-deploy via CircleCI
git commit --allow-empty -m "Trigger deployment"
git push origin main
```

### Problem: Users can't upload images
**Cause**: Backend `AWS_BUCKET` not configured or pointing to wrong bucket

**Solution**:
1. Go to AWS Console → Elastic Beanstalk → Configuration → Software
2. Verify `AWS_BUCKET=udagram-media-d5acd6ba`
3. Restart application

### Problem: Frontend website not loading
**Cause**: Frontend bucket missing files or website hosting not enabled

**Solution**:
1. Verify files exist: `aws s3 ls s3://udagram-frontend-d5acd6ba/`
2. Check website hosting: `aws s3api get-bucket-website --bucket udagram-frontend-d5acd6ba`
3. Re-deploy via CircleCI if needed

---

**Remember**: Two buckets, two purposes, two different `AWS_BUCKET` configurations! 🎯

