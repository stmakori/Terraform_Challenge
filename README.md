# Terraform Challenge (AWS)

My day-by-day work through a Terraform-on-AWS challenge, from a single EC2 web server to a
multi-region, highly available stack with remote state, automated tests, CI pipelines and policy
as code.

Every folder is a self-contained exercise you can `init`, `plan` and `apply` on its own.

## What this covers

- **Core Terraform**: providers, variables, outputs, data sources, `count` and `for_each`, lifecycle rules
- **State**: S3 remote backend with DynamoDB locking, workspaces, and file-layout isolation per environment
- **Modules**: a reusable `webserver_cluster` module evolved over several days, with module versioning and live/modules separation
- **Load balancing and scaling**: ALB, launch templates, Auto Scaling Groups, scaling policies and zero-downtime deployments (`create_before_destroy`)
- **Secrets**: AWS Secrets Manager for database credentials, sensitive variables and outputs
- **Multiple providers**: aliased providers for multi-region, S3 cross-region replication, Docker and Kubernetes (EKS) providers
- **Testing**: Terratest (Go) for the web server cluster module
- **CI/CD and governance**: GitHub Actions (fmt, validate, plan, immutable plan artifacts), Terraform Cloud, Sentinel policies and cost estimation
- **Observability**: CloudWatch alarms and SNS notifications

## Day by day

| Day | Folder | What it builds |
|---|---|---|
| 4 | [`Day 4 Challenge`](Day%204%20Challenge) | Configurable web server and a clustered web server behind an ALB with a launch template |
| 6 | [`Day 6 Challenge`](Day%206%20Challenge) | Remote state: encrypted, versioned S3 bucket with DynamoDB state locking |
| 7 | [`DAY 7`](DAY%207) | State isolation two ways: workspaces vs. separate environment folders |
| 8 | [`Day_8`](Day_8) | First reusable `webserver_cluster` module (ALB + ASG) with a live/modules layout |
| 9 | [`day_9`](day_9) | Module refinements: security group rules as separate `aws_security_group_rule` resources |
| 10 | [`Day_10`](Day_10) | Loops: `count` vs. `for_each` (IAM users), plus an autoscaling policy on the cluster |
| 11 | [`Day_11`](Day_11) | Conditionals: production vs. non-production sizing, Route 53 DNS records and CloudWatch alarms |
| 12 | [`Day_12`](Day_12) | Zero-downtime deployment of the cluster with `create_before_destroy` |
| 13 | [`Day_13`](Day_13) | RDS database with credentials pulled from AWS Secrets Manager |
| 14 | [`Day_14`](Day_14) | Multiple regions with provider aliases: S3 cross-region replication |
| 15 | [`Day_15`](Day_15) | Multi-region app module, Docker provider, and a Kubernetes deployment on EKS |
| 16 | [`Day_16`](Day_16) | Production-grade module: alarms, SNS, encrypted state, and a Terratest test |
| 17 | [`Day_17`](Day_17) | Web cluster with ALB listener rules and user-data bootstrapping |
| 18 | [`Day_18`](Day_18) | Automated testing: networking and services modules with a Terratest suite |
| 19 | [`day19-iac`](day19-iac) | IaC adoption: bootstrap backend, then infra, with a CI plan on every push |
| 20 | [`day20-iac`](day20-iac) | Application deployment workflow: plan -> review -> apply with saved plans |
| 21 | [`day21-iac`](day21-iac) | Infrastructure deployment workflow with CloudWatch alarms and Sentinel policies |
| 22 | [`day22-iac`](day22-iac) | Integrated workflow: Terraform Cloud backend, Sentinel, cost estimation, plan artifacts in CI |
| 25 | [`day25-static-website`](day25-static-website) | Static website on S3 as a reusable module with per-environment config |
| 26 | [`day26-scalable-web-app`](day26-scalable-web-app) | Scalable web app: custom VPC, ALB, ASG with scaling policies, split into modules |
| 27 | [`day27-multi-region-ha`](day27-multi-region-ha) | Multi-region high availability: VPC, ALB and ASG modules, Route 53 records and a Multi-AZ RDS module |

## Running an exercise

Prerequisites: [Terraform](https://developer.hashicorp.com/terraform/install) 1.5+, an AWS account,
and credentials configured (`aws configure` or environment variables). Go 1.21+ for the Terratest days.

```bash
cd Day_8/live/dev   # any exercise folder with a provider block
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

Exercises that use a remote backend expect the S3 bucket and DynamoDB table from Day 6 (or the
`bootstrap/` folder in Day 19) to exist first.

Secrets are never committed. Pass them as variables, environment variables (`TF_VAR_db_password`)
or Secrets Manager. See `Day_13/db-creds.example.json` for the secret's shape.

> **Cost warning:** many exercises create billable resources (ALBs, NAT, RDS, EKS).
> Run `terraform destroy` when you're done.
