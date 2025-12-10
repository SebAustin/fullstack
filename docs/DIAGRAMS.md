# Udagram Architecture and Pipeline Diagrams

This document contains visual diagrams for the Udagram application infrastructure and CI/CD pipeline.

---

## 📐 Infrastructure Architecture Diagram

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                           USERS / BROWSERS                          │
│                         (Internet Clients)                          │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ HTTP/HTTPS Requests
                             │
┌────────────────────────────▼────────────────────────────────────────┐
│                         AWS CLOUD                                   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │                  FRONTEND LAYER (S3)                        │  │
│  │                                                             │  │
│  │   ┌─────────────────────────────────────────────────┐      │  │
│  │   │  S3 Bucket: udagram-frontend-d5acd6ba           │      │  │
│  │   │  - Static Website Hosting Enabled               │      │  │
│  │   │  - Angular/Ionic Application                    │      │  │
│  │   │  - HTML, CSS, JavaScript Files                  │      │  │
│  │   │  - Public Read Access                           │      │  │
│  │   └─────────────────────┬───────────────────────────┘      │  │
│  │                         │                                   │  │
│  └─────────────────────────┼───────────────────────────────────┘  │
│                            │                                       │
│                            │ API Calls (HTTP)                      │
│                            │                                       │
│  ┌─────────────────────────▼───────────────────────────────────┐  │
│  │              BACKEND API LAYER (Elastic Beanstalk)          │  │
│  │                                                             │  │
│  │   ┌─────────────────────────────────────────────────┐      │  │
│  │   │  EB Environment: udagram-api-dev                │      │  │
│  │   │  - Node.js 18 / Amazon Linux 2023              │      │  │
│  │   │  - Express.js RESTful API                      │      │  │
│  │   │  - JWT Authentication                          │      │  │
│  │   │  - Auto-scaling & Load Balancing              │      │  │
│  │   └────────┬───────────────────────┬────────────────┘      │  │
│  │            │                       │                        │  │
│  └────────────┼───────────────────────┼────────────────────────┘  │
│               │                       │                            │
│               │                       │                            │
│     SQL       │                       │ File Upload/Retrieval      │
│     Queries   │                       │ (Images)                   │
│               │                       │                            │
│  ┌────────────▼────────────┐  ┌───────▼─────────────────────────┐ │
│  │   DATABASE LAYER (RDS)  │  │  STORAGE LAYER (S3)             │ │
│  │                         │  │                                 │ │
│  │  ┌──────────────────┐   │  │  ┌──────────────────────────┐  │ │
│  │  │ PostgreSQL DB    │   │  │  │ S3: udagram-media-       │  │ │
│  │  │ udagram-database │   │  │  │     d5acd6ba             │  │ │
│  │  │ - User data      │   │  │  │ - User uploaded images   │  │ │
│  │  │ - Feed items     │   │  │  │ - Public read access     │  │ │
│  │  │ - Metadata       │   │  │  │ - Object storage         │  │ │
│  │  └──────────────────┘   │  │  └──────────────────────────┘  │ │
│  │                         │  │                                 │ │
│  └─────────────────────────┘  └─────────────────────────────────┘ │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Component Details

| Component | Service | Purpose | Configuration |
|-----------|---------|---------|---------------|
| **Frontend** | AWS S3 | Serves static web application | Static hosting enabled, CORS configured |
| **Backend API** | AWS Elastic Beanstalk | Hosts Node.js Express API | Node.js 18, t2.medium instance |
| **Database** | AWS RDS | PostgreSQL database | PostgreSQL 14.15, db.t3.micro |
| **Media Storage** | AWS S3 | Stores user uploads | Public read, secure write via API |

### Data Flow

1. **User → Frontend (S3)**
   - User accesses `http://udagram-frontend-d5acd6ba.s3-website-us-east-1.amazonaws.com`
   - S3 serves static files (HTML, CSS, JS)

2. **Frontend → Backend API (EB)**
   - Angular app makes API calls to `http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com/api/v0`
   - JWT authentication for protected endpoints

3. **Backend → Database (RDS)**
   - API queries PostgreSQL database for user data and feed items
   - Connection via Sequelize ORM

4. **Backend → Media Storage (S3)**
   - API uploads user images to S3
   - API generates signed URLs for secure access

---

## 🔄 CI/CD Pipeline Diagram

### Complete Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                      DEVELOPMENT PHASE                              │
└─────────────────────────────────────────────────────────────────────┘

    ┌──────────────┐
    │  Developer   │
    │  Local Code  │
    └──────┬───────┘
           │
           │ git add, git commit
           │
           ▼
    ┌──────────────┐
    │   git push   │
    │   to main    │
    └──────┬───────┘
           │
           │
┌──────────▼──────────────────────────────────────────────────────────┐
│                     SOURCE CONTROL (GitHub)                         │
│                                                                     │
│   Repository: SebAustin/fullstack                                  │
│   Branch: main                                                     │
│   Trigger: Push event webhook → CircleCI                          │
└──────────┬──────────────────────────────────────────────────────────┘
           │
           │ Webhook notification
           │
┌──────────▼──────────────────────────────────────────────────────────┐
│                   CI/CD PLATFORM (CircleCI)                         │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │                    BUILD JOB                                │  │
│  │  Docker Image: cimg/node:16.20                             │  │
│  │                                                             │  │
│  │  Steps:                                                     │  │
│  │  1. ✓ Checkout code from GitHub                            │  │
│  │  2. ✓ Install frontend dependencies (npm)                  │  │
│  │  3. ✓ Install backend dependencies (npm)                   │  │
│  │  4. ✓ Lint frontend code (ESLint)                          │  │
│  │  5. ✓ Build frontend (Angular/Ionic)                       │  │
│  │  6. ✓ Build backend (TypeScript compilation)               │  │
│  │                                                             │  │
│  │  Output: ✅ Build Artifacts Ready                           │  │
│  └────────────────────────┬────────────────────────────────────┘  │
│                           │                                        │
│                           │ On Success                             │
│                           │                                        │
│  ┌────────────────────────▼───────────────────────────────────┐   │
│  │                    HOLD JOB                                │   │
│  │  (Manual Approval Required)                                │   │
│  │                                                             │   │
│  │  ⏸️  Waiting for manual approval...                        │   │
│  │  👤 Reviewer must click "Approve"                          │   │
│  └────────────────────────┬───────────────────────────────────┘   │
│                           │                                        │
│                           │ After Approval                         │
│                           │                                        │
│  ┌────────────────────────▼───────────────────────────────────┐   │
│  │                   DEPLOY JOB                               │   │
│  │  Docker Image: cimg/node:16.20                             │   │
│  │  Orbs: AWS CLI, EB CLI                                     │   │
│  │                                                             │   │
│  │  Steps:                                                     │   │
│  │  1. ✓ Install Node.js                                      │   │
│  │  2. ✓ Install AWS CLI                                      │   │
│  │  3. ✓ Install EB CLI                                       │   │
│  │  4. ✓ Configure AWS credentials (from env vars)            │   │
│  │  5. 🚀 Deploy Backend to Elastic Beanstalk                 │   │
│  │  6. 🚀 Deploy Frontend to S3                               │   │
│  │                                                             │   │
│  │  Output: ✅ Deployment Complete                             │   │
│  └────────────────────────┬───────────────────────────────────┘   │
│                           │                                        │
└───────────────────────────┼────────────────────────────────────────┘
                            │
                            │ Deployment
                            │
            ┌───────────────┴───────────────┐
            │                               │
            ▼                               ▼
┌───────────────────────┐       ┌───────────────────────┐
│   AWS S3 (Frontend)   │       │ AWS Elastic Beanstalk │
│   udagram-frontend-   │       │   udagram-api-dev     │
│   d5acd6ba            │       │   (Backend API)       │
│                       │       │                       │
│   Updated: ✅         │       │   Updated: ✅         │
└───────────────────────┘       └───────────────────────┘
            │                               │
            └───────────────┬───────────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │   LIVE APPLICATION    │
                │   Users can access    │
                │   updated version     │
                └───────────────────────┘
```

### Pipeline Stages Breakdown

#### Stage 1: Source Control
- **Trigger**: Git push to `main` branch
- **Action**: GitHub webhook notifies CircleCI
- **Duration**: Instant

#### Stage 2: Build Job
- **Purpose**: Compile and validate code
- **Steps**:
  1. Checkout code
  2. Install dependencies (frontend & backend)
  3. Lint code (ESLint/TSLint)
  4. Build applications (Angular + TypeScript)
- **Duration**: ~3-5 minutes
- **Failure**: Pipeline stops, no deployment

#### Stage 3: Hold (Manual Approval)
- **Purpose**: Human review before production deployment
- **Action**: Reviewer approves via CircleCI UI
- **Duration**: Variable (seconds to hours)
- **Benefit**: Prevents automatic deployment of untested code

#### Stage 4: Deploy Job
- **Purpose**: Deploy to AWS production environment
- **Backend Deployment**:
  - Package compiled code
  - Upload to Elastic Beanstalk
  - EB updates application version
  - Rolling update (zero downtime)
- **Frontend Deployment**:
  - Upload build files to S3
  - Update S3 objects
  - CloudFront invalidation (if CDN enabled)
- **Duration**: ~2-4 minutes

---

## 🔐 Security Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        SECURITY LAYERS                              │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Application Level                                           │  │
│  │  - JWT Authentication                                        │  │
│  │  - Password Hashing (bcrypt)                                │  │
│  │  - Input Validation                                         │  │
│  │  - CORS Configuration                                       │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Network Level                                               │  │
│  │  - Security Groups                                          │  │
│  │  - VPC Configuration                                        │  │
│  │  - RDS: Only allow EB security group                       │  │
│  │  - S3: Bucket policies for restricted write               │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  IAM Level                                                   │  │
│  │  - Limited IAM user permissions                             │  │
│  │  - Service roles (EB instance profile)                     │  │
│  │  - Access keys rotation                                    │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Environment Variables                                       │  │
│  │  - Secrets stored in CircleCI                              │  │
│  │  - EB environment properties                               │  │
│  │  - Never committed to Git                                  │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🌐 Network Architecture

```
Internet Gateway
      │
      ├─────────────────────────────────────────┐
      │                                         │
      │                                         │
      ▼                                         ▼
┌──────────────┐                     ┌──────────────────────┐
│  S3 Bucket   │                     │  Elastic Beanstalk   │
│  (Frontend)  │                     │  Application         │
│              │                     │                      │
│  Public      │                     │  ┌────────────────┐  │
│  Access      │                     │  │ EC2 Instance   │  │
│              │                     │  │ (API Server)   │  │
└──────────────┘                     │  │                │  │
                                     │  │ Security Group │  │
                                     │  │ - HTTP: 80     │  │
                                     │  └────────┬───────┘  │
                                     │           │          │
                                     └───────────┼──────────┘
                                                 │
                                                 │ Port 5432
                                                 │
                                     ┌───────────▼──────────┐
                                     │  RDS PostgreSQL      │
                                     │                      │
                                     │  Security Group      │
                                     │  - Allow from EB SG  │
                                     │  - Port 5432         │
                                     └──────────────────────┘
```

---

## 📊 Deployment Workflow Summary

| Step | Component | Action | Tool | Duration |
|------|-----------|--------|------|----------|
| 1 | Developer | Code & Push | Git | Instant |
| 2 | GitHub | Trigger webhook | GitHub Actions | Instant |
| 3 | CircleCI | Build & Test | CI/CD Pipeline | 3-5 min |
| 4 | Reviewer | Approve deployment | Manual | Variable |
| 5 | CircleCI | Deploy Backend | EB CLI | 2-3 min |
| 6 | CircleCI | Deploy Frontend | AWS CLI | 30-60 sec |
| 7 | AWS | Live update | S3 + EB | Instant |

**Total Automated Time**: ~6-9 minutes (excluding manual approval)

---

## 🎯 Key Benefits of This Architecture

### Scalability
- **Frontend**: S3 can handle millions of requests
- **Backend**: EB auto-scaling based on load
- **Database**: RDS can be scaled vertically or with read replicas

### Reliability
- **Frontend**: S3 provides 99.99% availability
- **Backend**: EB health monitoring and auto-recovery
- **Database**: RDS automated backups and multi-AZ option

### Security
- **Layered security**: Application, network, and IAM levels
- **Secret management**: Environment variables never in code
- **Network isolation**: Security groups restrict access

### Cost Efficiency
- **Free tier eligible**: t2.micro, db.t3.micro
- **Pay-as-you-go**: Only pay for what you use
- **Auto-scaling**: Scale down during low traffic

### Maintainability
- **Infrastructure as Code**: Terraform for reproducibility
- **Automated deployment**: CircleCI handles deployments
- **Version control**: Git tracks all changes
- **Monitoring**: CloudWatch for logs and metrics

---

## 📝 Notes

- **Diagrams are simplified** for clarity and understanding
- **Actual AWS implementation** may have additional components (NAT gateways, load balancers, etc.)
- **Security groups and network ACLs** are not shown but are configured
- **This architecture follows AWS Well-Architected Framework** principles

---

**For more detailed information**, see:
- [Infrastructure Description](Infrastructure_description.md)
- [Pipeline Description](Pipeline_description.md)
- [Application Dependencies](Application_dependencies.md)

