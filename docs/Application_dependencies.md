# Application Dependencies

## Overview

The Udagram application is a full-stack JavaScript application consisting of two main components: a frontend (Angular/Ionic) and a backend (Node.js/Express). This document provides a comprehensive list of all dependencies used in both parts of the application.

## Technology Stack

### Frontend
- **Framework**: Angular 8.x
- **UI Framework**: Ionic 4.x
- **Language**: TypeScript 3.5.x
- **Build Tool**: Angular CLI 8.x

### Backend
- **Runtime**: Node.js 14.15.0
- **Framework**: Express 4.x
- **Language**: TypeScript 4.2.x
- **ORM**: Sequelize 6.x
- **Database**: PostgreSQL 12.x/13.x

### Cloud Services
- **Hosting**: AWS (S3, Elastic Beanstalk, RDS)
- **CI/CD**: CircleCI

## Node.js Version Requirements

- **Required**: Node.js v14.15.0 (LTS)
- **Compatible**: v12.14 to v14.15
- **NPM Version**: 6.14.8 or higher

## Root Level Dependencies

Located in: `/package.json`

The root-level package.json contains scripts for managing both frontend and backend applications:

```json
{
  "scripts": {
    "frontend:install": "cd udagram/udagram-frontend && npm install -f",
    "frontend:start": "cd udagram/udagram-frontend && npm run start",
    "frontend:build": "cd udagram/udagram-frontend && npm run build",
    "frontend:test": "cd udagram/udagram-frontend && npm run test",
    "frontend:e2e": "cd udagram/udagram-frontend && npm run e2e",
    "frontend:lint": "cd udagram/udagram-frontend && npm run lint",
    "frontend:deploy": "cd udagram/udagram-frontend && npm run deploy",
    "api:install": "cd udagram/udagram-api && npm install .",
    "api:build": "cd udagram/udagram-api && npm run build",
    "api:start": "cd udagram/udagram-api && npm run dev",
    "api:deploy": "cd udagram/udagram-api && npm run deploy",
    "deploy": "npm run api:deploy && npm run frontend:deploy"
  }
}
```

## Backend API Dependencies

Located in: `/udagram/udagram-api/package.json`

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `aws-sdk` | ^2.429.0 | AWS services SDK for S3 operations |
| `bcryptjs` | 2.4.3 | Password hashing and verification |
| `body-parser` | ^1.18.3 | Parse incoming request bodies |
| `cors` | ^2.8.5 | Enable Cross-Origin Resource Sharing |
| `dotenv` | ^8.2.0 | Load environment variables from .env file |
| `email-validator` | ^2.0.4 | Email address validation |
| `express` | ^4.16.4 | Web application framework |
| `jsonwebtoken` | ^8.5.1 | JWT authentication token generation |
| `pg` | ^8.7.1 | PostgreSQL client for Node.js |
| `reflect-metadata` | ^0.1.13 | Metadata reflection API for TypeScript |
| `sequelize` | ^6.26.0 | Promise-based ORM for PostgreSQL |
| `sequelize-typescript` | ^2.1.5 | TypeScript decorators for Sequelize |
| `@types/bcryptjs` | 2.4.2 | TypeScript types for bcryptjs |
| `@types/jsonwebtoken` | ^8.3.2 | TypeScript types for jsonwebtoken |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `@types/bluebird` | ^3.5.26 | TypeScript types for Bluebird promises |
| `@types/cors` | ^2.8.6 | TypeScript types for CORS |
| `@types/express` | ^4.16.1 | TypeScript types for Express |
| `@types/node` | ^11.11.6 | TypeScript types for Node.js |
| `@types/sequelize` | ^4.28.14 | TypeScript types for Sequelize |
| `@types/validator` | ^13.7.10 | TypeScript types for validator |
| `@typescript-eslint/eslint-plugin` | ^2.19.2 | ESLint plugin for TypeScript |
| `@typescript-eslint/parser` | ^2.19.2 | TypeScript parser for ESLint |
| `chai` | ^4.2.0 | BDD/TDD assertion library |
| `chai-http` | ^4.2.1 | HTTP integration testing with Chai |
| `eslint` | ^6.8.0 | JavaScript/TypeScript linting tool |
| `eslint-config-google` | ^0.14.0 | Google's ESLint configuration |
| `mocha` | ^6.1.4 | Testing framework |
| `ts-node-dev` | ^1.0.0-pre.32 | TypeScript execution with auto-reload |
| `typescript` | ^4.2.3 | TypeScript compiler |

### Key Backend Dependencies Explained

#### AWS SDK
- **Purpose**: Interact with AWS services, specifically S3 for storing uploaded images
- **Usage**: Upload, download, and manage files in S3 buckets

#### Sequelize
- **Purpose**: ORM (Object-Relational Mapping) for PostgreSQL database
- **Features**: 
  - Models for User and FeedItem
  - Database migrations
  - Query building
  - Connection pooling

#### Express
- **Purpose**: Web application framework
- **Features**:
  - RESTful API routing
  - Middleware support
  - HTTP request/response handling

#### JWT (jsonwebtoken)
- **Purpose**: Authentication and authorization
- **Usage**: Generate and verify JWT tokens for user sessions

#### bcryptjs
- **Purpose**: Password security
- **Usage**: Hash passwords before storing, verify passwords on login

## Frontend Dependencies

Located in: `/udagram/udagram-frontend/package.json`

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `@angular/common` | ^8.2.14 | Common Angular functionality |
| `@angular/core` | ^8.2.14 | Core Angular framework |
| `@angular/forms` | ^8.2.14 | Form handling and validation |
| `@angular/http` | ^7.2.16 | HTTP client (legacy, pre-HttpClient) |
| `@angular/platform-browser` | ^8.2.14 | Browser-specific rendering |
| `@angular/platform-browser-dynamic` | ^8.2.14 | Dynamic component loading |
| `@angular/router` | ^8.2.14 | Client-side routing |
| `@ionic-native/core` | ^5.0.0 | Ionic Native core functionality |
| `@ionic-native/splash-screen` | ^5.0.0 | Native splash screen plugin |
| `@ionic-native/status-bar` | ^5.0.0 | Native status bar plugin |
| `@ionic/angular` | ^4.1.0 | Ionic Framework for Angular |
| `core-js` | ^2.5.4 | Polyfills for JavaScript features |
| `rxjs` | ~6.5.4 | Reactive programming library |
| `zone.js` | ~0.9.1 | Execution context tracking |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `@angular-devkit/architect` | ~0.12.3 | Angular build architect |
| `@angular-devkit/build-angular` | ^0.803.24 | Angular build tooling |
| `@angular-devkit/core` | ~7.2.3 | Angular DevKit core utilities |
| `@angular-devkit/schematics` | ~7.2.3 | Code generation schematics |
| `@angular/cli` | ~8.3.25 | Angular command-line interface |
| `@angular/compiler` | ~8.2.14 | Angular template compiler |
| `@angular/compiler-cli` | ~8.2.14 | Angular compiler CLI |
| `@angular/language-service` | ~8.2.14 | Angular language service for IDEs |
| `@ionic/angular-toolkit` | ~1.4.0 | Ionic-specific Angular builders |
| `@types/jasmine` | ~2.8.8 | TypeScript types for Jasmine |
| `@types/jasminewd2` | ~2.0.3 | TypeScript types for Jasmine WebDriver |
| `@types/node` | ~10.12.0 | TypeScript types for Node.js |
| `@typescript-eslint/eslint-plugin` | ^2.20.0 | ESLint plugin for TypeScript |
| `@typescript-eslint/parser` | ^2.20.0 | TypeScript parser for ESLint |
| `codelyzer` | ~4.5.0 | Linting rules for Angular/TypeScript |
| `jasmine-core` | ~2.99.1 | Jasmine testing framework core |
| `jasmine-spec-reporter` | ~4.2.1 | Spec results reporter for Jasmine |
| `karma` | ~3.1.4 | Test runner |
| `karma-chrome-launcher` | ~2.2.0 | Karma launcher for Chrome |
| `karma-coverage-istanbul-reporter` | ~2.0.1 | Code coverage reporter |
| `karma-jasmine` | ~1.1.2 | Jasmine adapter for Karma |
| `karma-jasmine-html-reporter` | ^0.2.2 | HTML reporter for Karma |
| `protractor` | ~5.4.0 | End-to-end testing framework |
| `ts-node` | ~8.0.0 | TypeScript execution for Node.js |
| `tslint` | ~5.12.0 | TypeScript linting tool |
| `typescript` | ^3.5.3 | TypeScript compiler |

### Key Frontend Dependencies Explained

#### Angular
- **Purpose**: Frontend application framework
- **Version**: 8.2.14
- **Features**:
  - Component-based architecture
  - Dependency injection
  - Two-way data binding
  - Routing and navigation

#### Ionic
- **Purpose**: Mobile-first UI component library
- **Version**: 4.1.0
- **Features**:
  - Pre-built UI components
  - Mobile-optimized styling
  - Touch gestures
  - Native device features

#### RxJS
- **Purpose**: Reactive programming with observables
- **Usage**:
  - HTTP requests
  - Event handling
  - State management
  - Async operations

## CI/CD Dependencies

### CircleCI Orbs

Located in: `.circleci/config.yml`

| Orb | Version | Purpose |
|-----|---------|---------|
| `circleci/node` | 5.0.2 | Node.js installation and management |
| `circleci/aws-cli` | 3.1.1 | AWS CLI installation and configuration |
| `circleci/aws-elastic-beanstalk` | 2.0.1 | Elastic Beanstalk CLI setup |

## System Dependencies

### Required System Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | 14.15.0 | JavaScript runtime |
| npm | 6.14.8+ | Package manager |
| AWS CLI | v2.x | AWS command-line interface |
| EB CLI | Latest | Elastic Beanstalk CLI |
| Git | 2.x+ | Version control |
| PostgreSQL Client | 12.x/13.x | Database client (psql) |

### Optional Development Tools

| Tool | Purpose |
|------|---------|
| Ionic CLI | v6.x for local development |
| Postman | API testing |
| pgAdmin | PostgreSQL GUI |
| VS Code | Code editor with TypeScript support |

## Database Dependencies

### PostgreSQL
- **Version**: 12.x or 13.x
- **Required Extensions**: None (uses standard PostgreSQL)
- **Connection**: Via `pg` npm package

### Database Schema
Managed by Sequelize migrations:
- `20190325-create-feed-item.js` - FeedItem table
- `20190328-create-user.js` - User table

## Environment Variables

### Backend Environment Variables

Required for the backend API to function:

```bash
POSTGRES_USERNAME=<username>
POSTGRES_PASSWORD=<password>
POSTGRES_HOST=<rds-endpoint>
POSTGRES_DB=postgres
AWS_BUCKET=<s3-bucket-name>
AWS_REGION=<aws-region>
AWS_PROFILE=default
JWT_SECRET=<secret-key>
URL=<frontend-url>
```

### Frontend Environment Variables

Configured in environment files:
- `src/environments/environment.ts` - Development
- `src/environments/environment.prod.ts` - Production

```typescript
export const environment = {
  production: false,
  appName: 'Udagram',
  apiHost: 'http://localhost:8080/api/v0'
};
```

## Installation Instructions

### Complete Installation

```bash
# Clone the repository
git clone <repository-url>
cd nd0067-c4-deployment-process-project-starter-master

# Install root dependencies (installs both frontend and backend)
npm run frontend:install
npm run api:install
```

### Backend Only

```bash
cd udagram/udagram-api
npm install .
```

### Frontend Only

```bash
cd udagram/udagram-frontend
npm install -f
# Note: -f flag forces installation despite peer dependency warnings
```

## Build Commands

### Backend Build

```bash
cd udagram/udagram-api
npm run build
# Compiles TypeScript and creates www/ directory
```

### Frontend Build

```bash
cd udagram/udagram-frontend
npm run build
# Creates production build in www/ directory
```

## Known Issues and Solutions

### Issue 1: Peer Dependency Warnings
**Problem**: npm shows peer dependency warnings during frontend installation

**Solution**: Use `npm install -f` to force installation

### Issue 2: fsevents Warning on Non-Mac Platforms
**Problem**: `fsevents` package warnings on Windows/Linux

**Solution**: Safe to ignore; fsevents is macOS-only

### Issue 3: Sequelize Version Compatibility
**Problem**: Sequelize v6 has breaking changes from v5

**Solution**: Using `sequelize-typescript` v2.1.5 which is compatible

### Issue 4: Angular Version Constraints
**Problem**: Some packages require specific Angular versions

**Solution**: Locked to Angular 8.2.14 in package.json

## Dependency Update Strategy

### Regular Updates
- Security patches: Update immediately
- Minor versions: Monthly review
- Major versions: Quarterly evaluation (with testing)

### Testing After Updates
1. Run local builds: `npm run build` for both apps
2. Run tests: `npm run test` (frontend)
3. Test locally: Start both apps and verify functionality
4. Deploy to staging environment
5. Run integration tests
6. Deploy to production

## Security Considerations

### Regular Security Audits

```bash
# Check for vulnerabilities
npm audit

# Fix automatically (use with caution)
npm audit fix

# Fix including breaking changes (use with extreme caution)
npm audit fix --force
```

### Dependency Scanning in CI/CD
- CircleCI can be configured to run `npm audit`
- Block builds with high/critical vulnerabilities
- Regular dependabot PRs for updates

## License Compliance

All dependencies used in this project are under permissive licenses:
- MIT License (majority)
- Apache 2.0
- BSD Licenses

No GPL or copyleft licenses that would restrict commercial use.

