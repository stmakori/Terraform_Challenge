# Day 22 - Integrated Terraform Workflow

## Features
- CI pipeline with plan artifact
- Terraform Cloud backend
- Sentinel policies
- Cost estimation enforcement
- Modular infrastructure

## Run locally

cd infra

terraform init
terraform plan -out=day22.tfplan
terraform apply day22.tfplan

## CI Pipeline
- Format check
- Validate
- Plan
- Upload immutable plan artifact

## Sentinel
- Restricts instance types
- Enforces tagging
- Blocks high cost changes
