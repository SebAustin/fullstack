# Screenshots Guide

This folder contains screenshots demonstrating the successful deployment of the Udagram application to AWS with CircleCI CI/CD pipeline.

## Required Screenshots

### CircleCI (`circleci/`)

**Required screenshots:**
1. `last-successful-build.png` - Overview of the last successful CircleCI build showing all jobs (build, hold, deploy) completed
2. `build-job.png` - Details of the build job showing all steps completed successfully
3. `deploy-job.png` - Details of the deploy job showing successful deployment to AWS
4. `environment-variables.png` - CircleCI project environment variables configuration (hide sensitive values)

**How to capture:**
- Navigate to your CircleCI project dashboard
- Click on a successful pipeline run
- Take screenshots of the workflow and individual job details
- For environment variables: Project Settings > Environment Variables

### AWS RDS (`aws-rds/`)

**Required screenshots:**
1. `database-overview.png` - RDS database instance overview showing status, endpoint, and configuration
2. `database-configuration.png` - Database configuration details (instance class, storage, etc.)
3. `security-group.png` - Security group inbound rules showing port 5432 access
4. `connectivity.png` - Connectivity and security settings

**How to capture:**
- Log into AWS Console
- Navigate to RDS service
- Select your PostgreSQL database instance
- Take screenshots of the Configuration tab and Connectivity & security sections

### AWS Elastic Beanstalk (`aws-eb/`)

**Required screenshots:**
1. `environment-dashboard.png` - EB environment dashboard showing health status (green/healthy)
2. `environment-configuration.png` - Environment configuration overview
3. `environment-variables.png` - Software configuration showing environment properties (hide sensitive values)
4. `application-versions.png` - Application versions page showing deployed versions
5. `logs.png` - Recent logs or log viewer showing application running successfully

**How to capture:**
- Navigate to Elastic Beanstalk service in AWS Console
- Select your environment (e.g., udagram-api-dev)
- Take screenshots from different tabs: Dashboard, Configuration, Logs

### AWS S3 (`aws-s3/`)

**Required screenshots:**
1. `bucket-overview.png` - S3 bucket overview showing frontend files uploaded
2. `bucket-properties.png` - Bucket properties showing static website hosting enabled
3. `bucket-permissions.png` - Bucket permissions and public access settings
4. `cors-configuration.png` - CORS configuration for the bucket
5. `bucket-policy.png` - Bucket policy (hide sensitive ARNs if necessary)

**How to capture:**
- Navigate to S3 service in AWS Console
- Select your frontend hosting bucket
- Take screenshots from: Overview, Properties, Permissions tabs

### Application (`application/`)

**Optional screenshots showing the running application:**
1. `homepage.png` - Frontend application homepage
2. `login-page.png` - User login interface
3. `registration-page.png` - User registration interface
4. `feed-page.png` - Photo feed showing images
5. `upload-page.png` - Photo upload interface
6. `api-health-check.png` - Browser showing successful API response (e.g., /api/v0/feed)

**How to capture:**
- Visit your deployed frontend URL
- Navigate through different pages and take screenshots
- For API health check: Visit your EB API endpoint in browser

## Screenshot Guidelines

### Best Practices
1. **Resolution**: Capture in high resolution (at least 1920x1080)
2. **Full Screen**: Show full browser window or AWS console for context
3. **Clear Text**: Ensure all text and details are readable
4. **Timestamps**: Include timestamps where visible to show recent activity
5. **Success Indicators**: Make sure green checkmarks, "Healthy" status, etc. are visible

### Sensitive Information
**Hide or blur the following:**
- AWS Account IDs (can keep last 4 digits visible)
- Secret keys and passwords
- Access key IDs
- Database passwords
- JWT secrets
- Personal email addresses (if any)

**Safe to show:**
- Region names
- Bucket names
- EB environment names
- RDS endpoints (public information once deployed)
- Public URLs

### File Naming Convention
- Use lowercase with hyphens
- Use descriptive names
- Include date if multiple versions: `screenshot-name-2024-12-04.png`
- Supported formats: PNG (preferred), JPG, JPEG

## Submission Checklist

Before submitting your project, ensure you have:

- [ ] At least 1 screenshot showing successful CircleCI build
- [ ] RDS database overview screenshot
- [ ] Elastic Beanstalk environment dashboard showing healthy status
- [ ] S3 bucket showing static website hosting configuration
- [ ] All sensitive information is hidden or blurred
- [ ] Screenshots are clear and readable
- [ ] All images are properly named and in the correct folders

## Example File Structure

```
screenshots/
├── README.md (this file)
├── circleci/
│   ├── last-successful-build.png
│   ├── build-job.png
│   └── deploy-job.png
├── aws-rds/
│   ├── database-overview.png
│   └── database-configuration.png
├── aws-eb/
│   ├── environment-dashboard.png
│   └── environment-variables.png
├── aws-s3/
│   ├── bucket-overview.png
│   └── bucket-properties.png
└── application/
    ├── homepage.png
    └── api-health-check.png
```

## When to Take Screenshots

1. **After successful AWS setup**: Capture RDS, S3, and EB configurations
2. **After first successful CircleCI deployment**: Capture the complete pipeline run
3. **After verifying application works**: Capture the running application
4. **Before final submission**: Review all screenshots for clarity and completeness

## Notes

- Screenshots are required by the Udacity project rubric
- They demonstrate that your deployment is successful and functional
- Keep original screenshots even if you make changes later
- Consider keeping screenshots organized by date for version tracking

---

**Tip**: Use your operating system's built-in screenshot tools or tools like Snagit, Greenshot, or macOS Screenshot utility for high-quality captures.

