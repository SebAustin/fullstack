# Udagram - Hosting a Full-Stack Application

[![CircleCI](https://circleci.com/gh/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.svg?style=svg)](https://circleci.com/gh/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME)

## Project Overview

Udagram is an Instagram-inspired image filtering application that allows users to register, log into a web client, post photos to a feed, and process photos using an image filtering service. This project demonstrates the deployment of a full-stack application to AWS cloud infrastructure with a fully automated CI/CD pipeline using CircleCI.

### Live Application

**Frontend URL**: http://your-s3-bucket-name.s3-website-us-east-1.amazonaws.com

**Backend API**: http://udagram-api-dev.eba-xxxxx.us-east-1.elasticbeanstalk.com/api/v0

> **Note**: Replace the URLs above with your actual deployed application URLs after completing the AWS setup.

## Application Architecture

The application consists of three main components:

1. **Frontend**: Angular/Ionic web application hosted on AWS S3
2. **Backend API**: Node.js/Express REST API hosted on AWS Elastic Beanstalk
3. **Database**: PostgreSQL database hosted on AWS RDS

## Technology Stack

### Frontend
- **Framework**: Angular 8.2.14
- **UI Library**: Ionic 4.1.0
- **Language**: TypeScript 3.5.3

### Backend
- **Runtime**: Node.js 14.15.0
- **Framework**: Express 4.16.4
- **Language**: TypeScript 4.2.3
- **ORM**: Sequelize 6.26.0
- **Database**: PostgreSQL 12.x/13.x

### Cloud & DevOps
- **Cloud Provider**: Amazon Web Services (AWS)
  - S3 (Frontend hosting & media storage)
  - Elastic Beanstalk (Backend API hosting)
  - RDS (PostgreSQL database)
- **CI/CD**: CircleCI
- **Version Control**: Git/GitHub

## Project Structure

```
.
├── .circleci/
│   └── config.yml              # CircleCI pipeline configuration
├── docs/
│   ├── Infrastructure_description.md   # AWS infrastructure documentation
│   ├── Pipeline_description.md         # CI/CD pipeline documentation
│   ├── Application_dependencies.md     # Dependencies documentation
│   └── AWS_setup_guide.md             # Step-by-step AWS setup guide
├── screenshots/
│   ├── circleci/               # CircleCI build screenshots
│   ├── aws-rds/                # RDS configuration screenshots
│   ├── aws-eb/                 # Elastic Beanstalk screenshots
│   └── aws-s3/                 # S3 bucket screenshots
├── udagram/
│   ├── udagram-api/            # Backend Node.js API
│   │   ├── src/                # Source code
│   │   ├── www/                # Compiled output (generated)
│   │   └── package.json        # Backend dependencies
│   ├── udagram-frontend/       # Frontend Angular app
│   │   ├── src/                # Source code
│   │   ├── www/                # Build output (generated)
│   │   └── package.json        # Frontend dependencies
│   └── set_env.sh              # Environment variables template
├── package.json                # Root-level scripts
└── README.md                   # This file
```

## Documentation

Comprehensive documentation is available in the `docs/` folder:

- **[Infrastructure Description](docs/Infrastructure_description.md)**: Details about AWS services, architecture diagrams, and resource specifications
- **[Pipeline Description](docs/Pipeline_description.md)**: CI/CD pipeline workflow, stages, and deployment process
- **[Application Dependencies](docs/Application_dependencies.md)**: Complete list of all dependencies and their purposes
- **[AWS Setup Guide](docs/AWS_setup_guide.md)**: Step-by-step instructions for setting up AWS resources

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js**: v14.15.0 (LTS) or compatible (v12.14 - v14.15)
  ```bash
  node -v  # Should show v14.x
  npm -v   # Should show v6.14.x or higher
  ```

- **PostgreSQL Client**: v12.x or v13.x
  ```bash
  psql --version
  ```

- **Ionic CLI**: v6.x
  ```bash
  npm install -g @ionic/cli
  ionic --version
  ```

- **AWS CLI**: v2.x
  ```bash
  aws --version
  ```

- **EB CLI**: Latest version
  ```bash
  eb --version
  ```

- **Git**: v2.x or higher
  ```bash
  git --version
  ```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

### 2. Install Dependencies

#### Install All Dependencies (Frontend + Backend)

```bash
npm run frontend:install
npm run api:install
```

#### Or Install Separately

**Backend:**
```bash
cd udagram/udagram-api
npm install .
```

**Frontend:**
```bash
cd udagram/udagram-frontend
npm install -f
```
> Note: The `-f` flag forces installation despite peer dependency warnings.

## Local Development

### 1. Set Up Environment Variables

```bash
cd udagram
cp set_env.sh set_env.sh.local
# Edit set_env.sh.local with your AWS credentials and database connection details
source set_env.sh.local
```

**Required Environment Variables:**
- `POSTGRES_USERNAME` - Database username
- `POSTGRES_PASSWORD` - Database password
- `POSTGRES_HOST` - RDS endpoint
- `POSTGRES_DB` - Database name (default: postgres)
- `AWS_BUCKET` - S3 bucket name for media storage
- `AWS_REGION` - AWS region (e.g., us-east-1)
- `JWT_SECRET` - Secret key for JWT tokens
- `URL` - Frontend URL

### 2. Run the Backend API

Open a terminal window:

```bash
# Make sure environment variables are loaded
source udagram/set_env.sh.local

# Navigate to the API directory
cd udagram/udagram-api

# Start the development server
npm run dev
```

The API will be available at: http://localhost:8080

Test the API: http://localhost:8080/api/v0/feed

### 3. Run the Frontend Application

Open a new terminal window:

```bash
cd udagram/udagram-frontend

# Start the development server
ionic serve
```

The application will be available at: http://localhost:8100

## Building for Production

### Build Backend

```bash
cd udagram/udagram-api
npm run build
```

This will:
- Compile TypeScript to JavaScript
- Output compiled code to `www/` directory
- Create deployment archive

### Build Frontend

```bash
cd udagram/udagram-frontend
npm run build
```

This will:
- Compile Angular/TypeScript code
- Create production-optimized bundles
- Output to `www/` directory

## AWS Setup

### Quick Setup Guide

1. **Create RDS PostgreSQL Database**
   - Instance class: db.t3.micro (free tier)
   - Public accessibility: Yes
   - Database name: postgres
   - Save the endpoint, username, and password

2. **Create S3 Buckets**
   - Frontend hosting bucket with static website hosting enabled
   - Configure bucket policy for public read access
   - Add CORS configuration

3. **Create Elastic Beanstalk Environment**
   ```bash
   cd udagram/udagram-api
   eb init
   eb create --single --keyname your-key-pair --instance-types t2.medium
   ```

4. **Configure Environment Variables in Elastic Beanstalk**
   - Set all environment variables in EB environment configuration

For detailed step-by-step instructions, see **[AWS Setup Guide](docs/AWS_setup_guide.md)**.

## Deployment

### Manual Deployment

#### Deploy Backend to Elastic Beanstalk

```bash
cd udagram/udagram-api
npm run deploy
```

#### Deploy Frontend to S3

```bash
cd udagram/udagram-frontend
npm run deploy
```

#### Deploy Both (from root directory)

```bash
npm run deploy
```

### Automated Deployment via CircleCI

The application uses CircleCI for automated deployment:

1. **Trigger**: Push to `main` or `master` branch
2. **Build**: Install dependencies, lint, and build both applications
3. **Hold**: Manual approval required
4. **Deploy**: Deploy backend to Elastic Beanstalk and frontend to S3

See **[Pipeline Description](docs/Pipeline_description.md)** for detailed information.

## CircleCI Setup

### 1. Sign Up for CircleCI

Create a free account at [circleci.com](https://circleci.com/)

### 2. Connect GitHub Repository

- Link your GitHub account
- Add your repository to CircleCI
- The `.circleci/config.yml` file will be automatically detected

### 3. Configure Environment Variables

In CircleCI project settings, add these environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `AWS_REGION`
- `AWS_BUCKET`
- `POSTGRES_USERNAME`
- `POSTGRES_PASSWORD`
- `POSTGRES_HOST`
- `POSTGRES_DB`
- `JWT_SECRET`
- `URL`

### 4. Trigger Build

Push to the main branch to trigger the pipeline:

```bash
git add .
git commit -m "Initial deployment setup"
git push origin main
```

## Testing

### Frontend Tests

```bash
cd udagram/udagram-frontend

# Unit tests
npm run test

# End-to-end tests
npm run e2e
```

### Backend Tests

```bash
cd udagram/udagram-api
npm run test
```

> Note: Backend tests are currently minimal. Future enhancements should include comprehensive unit and integration tests.

## Application Features

### User Authentication
- User registration with email validation
- Secure login with JWT tokens
- Password hashing with bcrypt

### Feed Management
- View photo feed from all users
- Upload photos (stored in S3)
- Image metadata stored in PostgreSQL

### Security
- JWT-based authentication
- Password encryption
- CORS configuration
- Environment-based configuration

## Screenshots

### Deployed Application
![Application Screenshot](screenshots/application/homepage.png)

### CircleCI Pipeline
![CircleCI Build](screenshots/circleci/last-successful-build.png)

### AWS Infrastructure
![AWS RDS](screenshots/aws-rds/database-overview.png)
![AWS Elastic Beanstalk](screenshots/aws-eb/environment-dashboard.png)
![AWS S3](screenshots/aws-s3/bucket-configuration.png)

> **Note**: Add actual screenshots to the `screenshots/` folder after completing the deployment.

## Troubleshooting

### Common Issues

#### 1. Local Connection to Database Fails

**Problem**: Can't connect to RDS from local machine

**Solutions**:
- Verify RDS security group allows your IP address
- Check that RDS has public accessibility enabled
- Verify connection string and credentials
- Test with psql: `psql -h YOUR_RDS_ENDPOINT -U postgres`

#### 2. Frontend Can't Connect to API

**Problem**: CORS errors or API not responding

**Solutions**:
- Verify `apiHost` in `environment.prod.ts` matches your EB URL
- Check EB environment is healthy and running
- Verify security group allows HTTP/HTTPS traffic
- Check CloudWatch logs for API errors

#### 3. CircleCI Build Fails

**Problem**: Build or deployment fails in CircleCI

**Solutions**:
- Check environment variables are set correctly
- Verify AWS credentials have required permissions
- Review build logs in CircleCI dashboard
- Test build locally: `npm run build`

#### 4. Elastic Beanstalk Health Check Fails

**Problem**: EB shows "Degraded" or "Severe" health status

**Solutions**:
- Check environment variables are set in EB configuration
- Review logs: `eb logs` or CloudWatch
- Verify database connectivity from EB
- Check application is listening on correct port

### Getting Help

- Review the [documentation](docs/) folder
- Check CircleCI build logs
- Review AWS CloudWatch logs
- Check Elastic Beanstalk health dashboard

## Performance Optimization

### Frontend
- Production build with AOT compilation
- Lazy loading for routes
- Tree shaking and minification
- Static asset caching

### Backend
- Database connection pooling
- Efficient Sequelize queries
- Express middleware optimization
- CloudWatch monitoring

### Infrastructure
- S3 CloudFront CDN (future enhancement)
- RDS read replicas (for scaling)
- Elastic Beanstalk auto-scaling (for production)

## Security Best Practices

1. **Never commit sensitive data**
   - Use environment variables for all secrets
   - Add `set_env.sh` to `.gitignore`
   - Use CircleCI's encrypted environment variables

2. **Database Security**
   - Use strong passwords
   - Limit security group access in production
   - Enable SSL connections
   - Regular backups

3. **API Security**
   - JWT token expiration
   - Input validation and sanitization
   - Rate limiting (future enhancement)
   - HTTPS only in production

4. **AWS Security**
   - IAM user with minimal required permissions
   - Regular credential rotation
   - Enable MFA on AWS account
   - Monitor AWS CloudTrail logs

## Future Enhancements

- [ ] Implement comprehensive test coverage
- [ ] Add image processing/filtering functionality
- [ ] Implement real-time updates with WebSockets
- [ ] Add CloudFront CDN for frontend
- [ ] Implement blue-green deployment strategy
- [ ] Add monitoring and alerting (CloudWatch, Sentry)
- [ ] Implement database migrations in CI/CD
- [ ] Add API rate limiting
- [ ] Implement caching strategy (Redis)
- [ ] Add end-to-end tests in CI/CD pipeline

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

## Acknowledgments

- Udacity Full Stack JavaScript Developer Nanodegree
- AWS for cloud infrastructure
- CircleCI for CI/CD platform
- Angular and Ionic teams for excellent frameworks

## Project Status

**Current Status**: ✅ Configured and ready for deployment

**Last Updated**: December 2025

---

## Author

**Your Name**
- GitHub: [@your-github-username](https://github.com/your-github-username)
- Email: your.email@example.com

---

## Support

For questions or issues related to this deployment project, please:
1. Check the [documentation](docs/) folder
2. Review the troubleshooting section above
3. Check CircleCI build logs
4. Open an issue on GitHub

---

**Built with ❤️ for the Udacity Full Stack JavaScript Developer Nanodegree**
