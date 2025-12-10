#!/bin/bash

# Terraform Quick Deploy Script for Udagram
# This script automates the Terraform deployment process

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Check if Terraform is installed
check_terraform() {
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed!"
        echo ""
        echo "Install Terraform:"
        echo "  macOS:   brew install terraform"
        echo "  Linux:   Visit https://terraform.io/downloads"
        echo "  Windows: choco install terraform"
        exit 1
    fi
    print_success "Terraform is installed: $(terraform version | head -n 1)"
}

# Check if AWS CLI is configured
check_aws() {
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed!"
        echo ""
        echo "Install AWS CLI:"
        echo "  macOS:   brew install awscli"
        echo "  Linux:   Visit https://aws.amazon.com/cli/"
        exit 1
    fi
    
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS CLI is not configured!"
        echo ""
        echo "Configure AWS CLI:"
        echo "  aws configure"
        exit 1
    fi
    
    print_success "AWS CLI is configured"
    aws sts get-caller-identity --output table
}

# Check if terraform.tfvars exists
check_tfvars() {
    if [ ! -f "terraform.tfvars" ]; then
        print_warning "terraform.tfvars not found!"
        echo ""
        print_info "Creating terraform.tfvars from example..."
        
        if [ -f "terraform.tfvars.example" ]; then
            cp terraform.tfvars.example terraform.tfvars
            print_success "Created terraform.tfvars"
            echo ""
            print_warning "IMPORTANT: Edit terraform.tfvars and set your database password!"
            echo ""
            echo "Press Enter to open terraform.tfvars in your default editor..."
            read -r
            ${EDITOR:-nano} terraform.tfvars
        else
            print_error "terraform.tfvars.example not found!"
            exit 1
        fi
    else
        print_success "terraform.tfvars exists"
    fi
}

# Initialize Terraform
terraform_init() {
    print_header "Initializing Terraform"
    terraform init
    print_success "Terraform initialized"
}

# Validate Terraform configuration
terraform_validate() {
    print_header "Validating Terraform Configuration"
    terraform validate
    print_success "Configuration is valid"
}

# Plan Terraform changes
terraform_plan() {
    print_header "Planning Infrastructure Changes"
    terraform plan -out=tfplan
    print_success "Plan created: tfplan"
}

# Apply Terraform changes
terraform_apply() {
    print_header "Creating AWS Infrastructure"
    print_warning "This will create real AWS resources and may incur costs."
    echo ""
    echo "Review the plan above carefully."
    echo ""
    read -p "Do you want to proceed? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        print_info "Deployment cancelled"
        exit 0
    fi
    
    print_info "Starting deployment... This will take 5-10 minutes."
    terraform apply tfplan
    print_success "Infrastructure created successfully!"
}

# Save outputs
save_outputs() {
    print_header "Saving Infrastructure Details"
    
    # Save summary (use -raw to get the actual value since it's marked sensitive)
    terraform output -raw summary > infrastructure-details.txt 2>/dev/null || \
    terraform output summary > infrastructure-details.txt 2>/dev/null || true
    
    if [ -f "infrastructure-details.txt" ]; then
        print_success "Details saved to: infrastructure-details.txt"
    fi
    
    # Save sensitive values to separate files
    terraform output -raw iam_access_key_id > .access_key_id 2>/dev/null || true
    terraform output -raw iam_secret_access_key > .secret_access_key 2>/dev/null || true
    terraform output -raw jwt_secret > .jwt_secret 2>/dev/null || true
    
    if [ -f ".access_key_id" ] && [ -f ".secret_access_key" ]; then
        print_success "Credentials saved to: .access_key_id, .secret_access_key, .jwt_secret"
        print_warning "Keep these files secure! They contain sensitive information."
    fi
}

# Display next steps
show_next_steps() {
    print_header "🎉 Infrastructure Successfully Created!"
    
    echo ""
    echo "📋 IMPORTANT: All details have been saved to infrastructure-details.txt"
    echo ""
    
    # Display the summary (it's sensitive, so might not show in all contexts)
    if terraform output summary > /dev/null 2>&1; then
        terraform output summary
    else
        print_info "View full details in: infrastructure-details.txt"
        echo ""
        echo "Quick access to key values:"
        echo "  RDS Endpoint: $(terraform output -raw rds_address 2>/dev/null || echo 'N/A')"
        echo "  Frontend URL: $(terraform output -raw s3_frontend_website_url 2>/dev/null || echo 'N/A')"
        echo "  Frontend Bucket: $(terraform output -raw s3_frontend_bucket 2>/dev/null || echo 'N/A')"
        echo "  Media Bucket: $(terraform output -raw s3_media_bucket 2>/dev/null || echo 'N/A')"
    fi
    
    echo ""
    print_header "📝 Next Steps"
    echo ""
    echo "1. Review infrastructure-details.txt for all values"
    echo ""
    echo "2. Test database connection:"
    echo "   psql -h \$(terraform output -raw rds_address) -U postgres -d postgres"
    echo ""
    echo "3. Configure AWS CLI with deployer credentials:"
    echo "   aws configure"
    echo "   # Use the Access Key ID and Secret from the output above"
    echo ""
    echo "4. Create Elastic Beanstalk environment:"
    echo "   cd ../udagram/udagram-api"
    echo "   eb init"
    echo "   eb create --single --instance-types t2.medium"
    echo ""
    echo "5. Update environment.prod.ts with your EB URL"
    echo ""
    echo "6. Set up CircleCI with the environment variables from above"
    echo ""
    echo "7. Deploy!"
    echo ""
}

# Destroy infrastructure (cleanup)
terraform_destroy() {
    print_header "⚠️  Destroying Infrastructure"
    print_error "This will DELETE all AWS resources!"
    echo ""
    echo "This includes:"
    echo "  - RDS Database (all data will be lost)"
    echo "  - S3 Buckets (all files will be deleted)"
    echo "  - IAM Users and access keys"
    echo "  - Security Groups"
    echo ""
    read -p "Are you ABSOLUTELY SURE you want to destroy everything? (type 'destroy' to confirm): " confirm
    
    if [ "$confirm" != "destroy" ]; then
        print_info "Destruction cancelled"
        exit 0
    fi
    
    print_warning "Destroying infrastructure..."
    terraform destroy
    print_success "Infrastructure destroyed"
}

# Main function
main() {
    print_header "🚀 Udagram Terraform Deployment"
    
    # Parse command line arguments
    case "${1:-deploy}" in
        deploy)
            check_terraform
            check_aws
            check_tfvars
            terraform_init
            terraform_validate
            terraform_plan
            terraform_apply
            save_outputs
            show_next_steps
            ;;
        destroy)
            terraform_destroy
            ;;
        plan)
            check_terraform
            check_aws
            check_tfvars
            terraform_init
            terraform_validate
            terraform_plan
            print_info "Plan created. Review it, then run './deploy.sh apply' to create resources"
            ;;
        apply)
            terraform_apply
            save_outputs
            show_next_steps
            ;;
        output)
            if [ -f "infrastructure-details.txt" ]; then
                cat infrastructure-details.txt
            else
                terraform output summary 2>/dev/null || \
                print_warning "No saved output found. Run './deploy.sh deploy' first."
            fi
            ;;
        *)
            echo "Usage: $0 {deploy|destroy|plan|apply|output}"
            echo ""
            echo "Commands:"
            echo "  deploy  - Full deployment (init, validate, plan, apply)"
            echo "  destroy - Destroy all infrastructure"
            echo "  plan    - Show what will be created"
            echo "  apply   - Apply a previously created plan"
            echo "  output  - Show infrastructure details"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

