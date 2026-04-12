# Day 20 - Terraform Application Deployment Workflow

## What this project demonstrates
- Application version update via user_data
- Full Terraform workflow simulation
- Plan -> Review -> Apply process
- EC2-based web server deployment

## Run

```bash
cd infra
terraform init
terraform plan -out=day20.tfplan
terraform apply day20.tfplan
```
