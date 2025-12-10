# 🔐 Configure RDS Security Group for EB Access

## ⚠️ Why This Is Needed

Your EB application needs to connect to your RDS database. Currently, the RDS security group may not allow connections from your EB environment.

**Current Setup:**
- RDS Instance: `udagram-database-d5acd6ba`
- RDS Security Group: `sg-0eaaac15ce2ced731`
- EB Environment: `udagram-api-dev`
- EB Security Group: (Need to find via console)

## 🎯 Step-by-Step Configuration

### Step 1: Find EB Security Group

1. Go to **AWS Console** → **EC2** → **Instances**
2. Search for instance with name containing `udagram-api-dev`
3. Click on the instance
4. Look at **Security** tab
5. Note the **Security groups** (e.g., `sg-xxxxx`)
6. **Copy this security group ID** - you'll need it!

### Step 2: Update RDS Security Group

1. Go to **AWS Console** → **EC2** → **Security Groups**
2. Search for security group: `sg-0eaaac15ce2ced731`
3. Click on it
4. Click **Edit inbound rules**
5. Click **Add rule**
6. Configure:
   - **Type**: PostgreSQL
   - **Protocol**: TCP
   - **Port**: 5432
   - **Source**: Custom
   - **Value**: [Paste the EB security group ID from Step 1]
   - **Description**: `Allow EB environment to connect`
7. Click **Save rules**

### Step 3: Verify

Wait 1-2 minutes, then test your API:

```bash
curl http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0/feed
```

Should return: `[]`

---

## 🖼️ Visual Guide

### Finding EB Security Group

```
AWS Console
  └── EC2
       └── Instances
            └── Find instance with "udagram-api-dev"
                 └── Security tab
                      └── Security groups: sg-xxxxx ← Copy this!
```

### Updating RDS Security Group

```
AWS Console
  └── EC2
       └── Security Groups
            └── Find: sg-0eaaac15ce2ced731 (RDS security group)
                 └── Edit inbound rules
                      └── Add rule
                           ├── Type: PostgreSQL
                           ├── Port: 5432
                           └── Source: [EB security group ID]
```

---

## 🔍 Alternative Method: Via AWS CLI

If you want to automate this (may not work in AWS Academy):

### Find EB Security Group

```bash
# Find EB instances
aws ec2 describe-instances \
  --filters "Name=tag:elasticbeanstalk:environment-name,Values=udagram-api-dev" \
  --query 'Reservations[*].Instances[*].[InstanceId,SecurityGroups[*].GroupId]' \
  --output table
```

### Add Rule to RDS Security Group

```bash
# Replace <EB_SG_ID> with the security group ID from above
EB_SG_ID="sg-xxxxx"  # Your EB security group ID
RDS_SG_ID="sg-0eaaac15ce2ced731"  # Your RDS security group ID

aws ec2 authorize-security-group-ingress \
  --group-id $RDS_SG_ID \
  --protocol tcp \
  --port 5432 \
  --source-group $EB_SG_ID \
  --group-owner-id $(aws sts get-caller-identity --query 'Account' --output text)
```

---

## ✅ Verification Steps

### 1. Check Security Group Rules

**Via Console:**
1. EC2 → Security Groups → `sg-0eaaac15ce2ced731`
2. Inbound rules should show:
   - PostgreSQL (5432) from EB security group

**Via CLI:**
```bash
aws ec2 describe-security-groups \
  --group-ids sg-0eaaac15ce2ced731 \
  --query 'SecurityGroups[*].IpPermissions'
```

### 2. Test API Connection

```bash
# Test feed endpoint
curl http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0/feed

# Should return: []
```

### 3. Check EB Logs for Database Errors

```bash
cd udagram/udagram-api
eb logs | grep -i "postgres\|database\|connection" | tail -20
```

---

## 🐛 Troubleshooting

### Still Can't Connect?

**Verify both security groups:**

1. **RDS Security Group** (`sg-0eaaac15ce2ced731`)
   - Must have inbound rule allowing PostgreSQL (5432) from EB security group

2. **EB Security Group**
   - Should allow outbound traffic on port 5432 (usually allowed by default)

### Database Connection Timeout

**Possible causes:**
- Security group rule not added correctly
- RDS instance not in same VPC as EB environment
- RDS database not publicly accessible and EB not in VPC

**Check:**
```bash
# Get RDS VPC
aws rds describe-db-instances \
  --query 'DBInstances[0].[DBInstanceIdentifier,DBSubnetGroup.VpcId]' \
  --output table

# Get EB VPC (via instance)
aws ec2 describe-instances \
  --filters "Name=tag:elasticbeanstalk:environment-name,Values=udagram-api-dev" \
  --query 'Reservations[*].Instances[*].VpcId' \
  --output table
```

They should be in the **same VPC**.

### Wrong Security Group ID?

Double-check you're using the correct security group IDs:

**RDS Security Group:**
```bash
cd terraform
terraform output | grep security
```

**EB Security Group:**
```bash
# Via console: EC2 → Instances → udagram-api-dev instance → Security tab
```

---

## 📋 Quick Checklist

- [ ] Found EB instance in EC2 console
- [ ] Copied EB security group ID
- [ ] Located RDS security group (`sg-0eaaac15ce2ced731`)
- [ ] Added inbound rule: PostgreSQL (5432) from EB SG
- [ ] Saved security group rules
- [ ] Waited 1-2 minutes
- [ ] Tested API endpoint - returns `[]`
- [ ] No database connection errors in logs

---

## 🎉 After Success

Once the security group is configured and API is responding:

1. **Set Environment Variables** (see `SET_EB_ENV_VARS.md`)
2. **Update Frontend Configuration**
3. **Test Full Application**
4. **Take Screenshots for Submission**

---

**🌐 Go to AWS Console now and configure the security group!**

This is a critical step for your application to connect to the database.

