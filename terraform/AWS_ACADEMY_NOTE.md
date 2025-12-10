# AWS Academy Compatibility Note

## ✅ Your Infrastructure is Complete!

All essential resources have been created successfully:

### Created Resources
- ✅ RDS PostgreSQL Database
- ✅ S3 Frontend Bucket (`udagram-frontend-d5acd6ba`)
- ✅ S3 Media Bucket (`udagram-media-d5acd6ba`)
- ✅ Security Groups (RDS & EB)
- ✅ JWT Secret (auto-generated)

### ⚠️ IAM Limitations in AWS Academy

AWS Academy restricts IAM operations, so Terraform cannot manage:
- ❌ Custom IAM users
- ❌ Custom IAM roles
- ❌ Custom IAM instance profiles

**This is OK!** Here's what to do instead:

## 🔧 Workarounds for AWS Academy

### 1. For CircleCI Credentials

**Instead of creating an IAM user, use your AWS Academy session credentials:**

1. Go to **AWS Academy** → Click **AWS Details** button
2. Copy these values:
   ```
   AWS_ACCESS_KEY_ID=xxx
   AWS_SECRET_ACCESS_KEY=xxx
   AWS_SESSION_TOKEN=xxx (if shown)
   ```
3. Add them to CircleCI environment variables

⏰ **Important**: These expire every few hours. You'll need to:
- Refresh them in CircleCI when they expire
- Or disable CircleCI auto-deployment and deploy manually

### 2. For Elastic Beanstalk Instance Profile

**Use the default AWS Elastic Beanstalk instance profile:**

When creating your EB environment, use the default profile:

```bash
# Option 1: Let EB create the default profile automatically
eb create udagram-api-dev --single --instance-types t2.medium

# Option 2: Specify the default EB instance profile
eb create udagram-api-dev \
  --single \
  --instance-types t2.medium \
  --instance_profile aws-elasticbeanstalk-ec2-role
```

If the default profile doesn't exist, EB will create it automatically!

### 3. Manual IAM Role Creation (If Needed)

If EB can't create the default role, create it manually:

1. Go to **AWS Console** → **IAM** → **Roles**
2. Click **Create role**
3. Select **AWS service** → **Elastic Beanstalk**
4. Choose **Elastic Beanstalk - EC2 role**
5. Name it: `aws-elasticbeanstalk-ec2-role`
6. Create role

Then create the instance profile:
1. **IAM** → **Roles** → Select your role
2. Note the role name
3. Use it with: `eb create --instance_profile aws-elasticbeanstalk-ec2-role`

## ✅ Current Status

Run this to see what you have:

```bash
terraform state list
```

You should see:
- ✅ aws_db_instance.postgres
- ✅ aws_s3_bucket.frontend
- ✅ aws_s3_bucket.media
- ✅ aws_security_group.rds_sg
- ✅ aws_security_group.eb_sg
- ✅ And more...

## 📋 Next Steps

Everything is ready! Continue with:

1. **Get RDS Endpoint** from AWS Console
2. **Create Elastic Beanstalk** environment
3. **Configure environment variables** in EB
4. **Update frontend** config with EB URL
5. **Set up CircleCI** with Academy credentials
6. **Deploy!**

See `QUICK_REFERENCE.txt` for exact commands.

## 🎯 This is Normal!

AWS Academy's IAM restrictions are expected. The workarounds above are standard practice for AWS Academy projects. Your infrastructure is complete and ready for deployment! 🚀

---

**Questions?** Check `INFRASTRUCTURE_SUMMARY.md` for full details.

