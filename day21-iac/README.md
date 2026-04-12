# Day 21 - Infrastructure Deployment Workflow

## What this project demonstrates
- Full Terraform deployment workflow
- Plan → Review → Apply discipline
- CloudWatch alarm integration
- Infrastructure safety practices

## Run

```bash
cd infra

terraform init

terraform plan -out=day21.tfplan

terraform apply day21.tfplan
```

## Verify

Check:
- EC2 instance is running
- CloudWatch alarm is created
- App responds with version v4
