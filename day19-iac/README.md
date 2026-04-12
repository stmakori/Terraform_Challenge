# Day 19 - IaC Adoption Project

## Structure
- bootstrap/ -> creates backend infrastructure
- infra/ -> main Terraform code
- GitHub Actions -> CI pipeline

## Steps

### 1. Bootstrap backend
cd bootstrap
terraform init
terraform apply

### 2. Deploy infra
cd infra
terraform init
terraform apply

### 3. CI/CD
Push to main triggers plan automatically
