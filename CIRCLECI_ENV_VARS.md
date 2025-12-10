# CircleCI Environment Variables - Quick Reference

Copy these exact values into your CircleCI Project Settings → Environment Variables:

## 🔐 Required Environment Variables

### AWS Credentials
| Variable Name | Value |
|--------------|-------|
| `AWS_ACCESS_KEY_ID` | ⚠️ **Get from AWS Academy Learner Lab** → AWS Details → Show → AWS CLI credentials |
| `AWS_SECRET_ACCESS_KEY` | ⚠️ **Get from AWS Academy Learner Lab** → AWS Details → Show → AWS CLI credentials |
| `AWS_DEFAULT_REGION` | `us-east-1` |
| `AWS_BUCKET` | `udagram-frontend-d5acd6ba` |

### Database (RDS)
| Variable Name | Value |
|--------------|-------|
| `POSTGRES_USERNAME` | `postgres` |
| `POSTGRES_PASSWORD` | `YourSecurePassword123!` |
| `POSTGRES_DB` | `postgres` |
| `POSTGRES_HOST` | `udagram-database-d5acd6ba.cnczxm1ccrvx.us-east-1.rds.amazonaws.com` |
| `PORT` | `5432` |

### Backend API
| Variable Name | Value |
|--------------|-------|
| `JWT_SECRET` | `8YhALt%YxYHqdvQpfw!N_@7rT?1e#>G%` |
| `URL` | `http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com` |

---

## 📝 How to Get AWS Credentials for CircleCI

Since you're using AWS Academy, your credentials are **temporary** and will expire when your lab session ends. Here's what to do:

### Option 1: Use AWS Academy Session Credentials (Temporary)

1. Go to AWS Academy Learner Lab
2. Click **AWS Details**
3. Click **Show** next to "AWS CLI credentials"
4. Copy the values for:
   - `aws_access_key_id`
   - `aws_secret_access_key`
   - `aws_session_token` (if required)

⚠️ **WARNING**: These credentials expire when your lab session ends. You'll need to update them in CircleCI for each lab session.

### Option 2: Create a Permanent IAM User (Recommended, if allowed)

If AWS Academy allows (it may not):

1. Go to AWS Console → IAM → Users
2. Create a new user (e.g., `circleci-deployer`)
3. Attach policies:
   - `AmazonS3FullAccess`
   - `ElasticBeanstalkFullAccess` (if available)
   - Custom policy for EB (see below)
4. Create Access Key
5. Copy Access Key ID and Secret Access Key
6. Use these in CircleCI (they won't expire)

**Custom EB Policy (if needed)**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticbeanstalk:*",
        "ec2:*",
        "s3:*",
        "cloudformation:*",
        "autoscaling:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## 🚀 How to Add Variables in CircleCI

1. Go to https://app.circleci.com/
2. Select your project: `SebAustin/fullstack`
3. Click **Project Settings** (top right)
4. Click **Environment Variables** (left sidebar)
5. For each variable above:
   - Click **Add Environment Variable**
   - Enter the **Name** (e.g., `AWS_ACCESS_KEY_ID`)
   - Enter the **Value** (e.g., your access key)
   - Click **Add Environment Variable**

---

## ✅ Verification Checklist

Before pushing to GitHub, verify:

- [ ] All 11 environment variables are set in CircleCI
- [ ] `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are from AWS Academy
- [ ] `AWS_BUCKET` matches your S3 bucket name: `udagram-frontend-d5acd6ba`
- [ ] `POSTGRES_HOST` does NOT include the port (`:5432`)
- [ ] `URL` matches your Elastic Beanstalk environment URL

---

## 🔄 After Setting Variables

1. Commit and push your code:
   ```bash
   git add .circleci/
   git commit -m "Add CircleCI configuration"
   git push origin main
   ```

2. Go to CircleCI and watch your pipeline run

3. When the "Hold" job appears, click **Approve** to start deployment

4. Monitor the deployment:
   - **Frontend**: Should deploy successfully to S3
   - **Backend**: May fail due to AWS Academy restrictions (deploy manually via console)

---

## 🆘 Troubleshooting

**Issue**: CircleCI says "AWS credentials not configured"
- **Solution**: Double-check `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION` are set

**Issue**: S3 deployment fails with AccessDenied
- **Solution**: Verify your AWS credentials in CircleCI have `s3:PutObject` permission. If using AWS Academy session credentials, they might be restricted.

**Issue**: EB deployment fails
- **Solution**: Expected with AWS Academy. Deploy backend manually via AWS Console (see `AWS_ACADEMY_EB_WORKAROUND.md`)

---

## 📞 Need Help?

- CircleCI Environment Variables Guide: https://circleci.com/docs/env-vars/
- AWS Academy Support: Check your course instructor or AWS Academy help

---

**Remember**: AWS Academy session credentials expire! If your CircleCI builds start failing with "InvalidAccessKeyId", update your AWS credentials in CircleCI with fresh session credentials from AWS Academy.

