# 🔧 Set Elastic Beanstalk Environment Variables

## ⚠️ Current Issue

Your API deployment is complete, but getting **502 Bad Gateway** because environment variables are missing.

```
✅ Deployment: Success
✅ Health: Green  
❌ API Response: 502 (No env vars)
```

## 🎯 Solution: Set Environment Variables via AWS Console

### Step-by-Step Guide

#### 1. Open AWS Console

Go to: https://console.aws.amazon.com/elasticbeanstalk

#### 2. Navigate to Your Application

```
Applications → udagram-api → udagram-api-dev
```

#### 3. Open Configuration

```
Left sidebar → Configuration
```

#### 4. Edit Software Settings

```
Find: "Software" category
Click: "Edit" button
Scroll down to: "Environment properties"
```

#### 5. Add Environment Variables

Click "Add environment property" for each one:

##### Database Configuration

```
Name: POSTGRES_HOST
Value: udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com
```

```
Name: POSTGRES_USERNAME
Value: postgres
```

```
Name: POSTGRES_PASSWORD
Value: YourSecurePassword123!
```

```
Name: POSTGRES_DB
Value: postgres
```

##### AWS Configuration

```
Name: AWS_BUCKET
Value: udagram-media-d5acd6ba
```

```
Name: AWS_REGION
Value: us-east-1
```

##### Application Configuration

```
Name: JWT_SECRET
Value: 8YhALt%YxYHqdvQpfw!N_@7rT?1e#>G%
```

```
Name: URL
Value: http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com
```

```
Name: PORT
Value: 8080
```

#### 6. Apply Changes

```
Click: "Apply" button at bottom
Wait: 2-3 minutes for environment update
Status: Should remain "Green"
```

#### 7. Verify

Once update completes, test your API:

```bash
curl http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0/feed
```

**Expected:** `[]` (empty JSON array)

---

## 📋 Quick Copy-Paste Values

For easy copying (use in AWS Console):

### All Variables in One Block

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

---

## 🔍 Verification After Setting Variables

### Option 1: Use Test Script

```bash
./test-api.sh
```

### Option 2: Manual Test

```bash
# Test feed endpoint
curl http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0/feed

# Check EB status
cd udagram/udagram-api
eb status

# Check environment variables (may not show all due to AWS Academy restrictions)
eb printenv
```

---

## 🐛 Troubleshooting

### Still Getting 502 After Setting Variables?

**Check logs:**

```bash
cd udagram/udagram-api
eb logs | grep -E "(error|Error|ERROR)" | tail -20
```

**Common issues:**
1. Database security group doesn't allow EB security group
2. Database password incorrect
3. Application not listening on port 8080
4. JWT_SECRET has special characters that need escaping

### Environment Variables Not Showing?

AWS Academy restricts `eb printenv`, but variables are still set. Test by:
1. Making an API call
2. Checking EB logs for connection errors

### Database Connection Failed?

**Verify security group:**
1. AWS Console → RDS → Your database
2. Click on security group
3. Inbound rules should allow:
   - Type: PostgreSQL (5432)
   - Source: EB security group (sg-09be6cec95faa58dd)

**Update security group if needed:**

```bash
cd terraform

# Get EB security group ID (should be: sg-09be6cec95faa58dd)
terraform output eb_security_group_id

# Manually add inbound rule to RDS security group allowing this SG
```

Or via AWS Console:
1. EC2 → Security Groups
2. Find your RDS security group
3. Edit inbound rules
4. Add: PostgreSQL (5432) from EB security group

---

## ✅ Success Checklist

After completing all steps:

- [ ] All 9 environment variables added in EB Console
- [ ] Clicked "Apply" and waited for update
- [ ] Environment health is "Green"
- [ ] API returns `[]` at `/api/v0/feed`
- [ ] No 502 errors

---

## 🎉 Next Steps After Success

1. **Update Frontend Configuration**
   - Edit `udagram-frontend/src/environments/environment.prod.ts`
   - Set `apiHost` to your EB URL
   - Redeploy frontend

2. **Test Full Stack**
   - Frontend can load
   - Frontend can call backend API
   - Can create/view feed items

3. **Take Screenshots**
   - EB dashboard showing Green/Healthy
   - EB environment variables configuration
   - API responding with data
   - Working frontend application

4. **Document**
   - Update README with deployment URL
   - Add screenshots to `screenshots/` folder
   - Note any AWS Academy limitations encountered

---

**🌐 Open AWS Console now and set those environment variables!**

Your API is deployed and ready - just needs configuration to connect to the database.

