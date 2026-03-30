provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

# Optional example for multi-account setup only.
# Uncomment and update role ARN if you actually have another account.
#
# provider "aws" {
#   alias  = "production"
#   region = var.primary_region
#
#   assume_role {
#     role_arn = "arn:aws:iam::111111111111:role/TerraformDeployRole"
#   }
# }
#
# provider "aws" {
#   alias  = "staging"
#   region = var.primary_region
#
#   assume_role {
#     role_arn = "arn:aws:iam::222222222222:role/TerraformDeployRole"
#   }
# }

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  primary_bucket_name = "${var.project_name}-primary-${random_id.suffix.hex}"
  replica_bucket_name = "${var.project_name}-replica-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "primary" {
  bucket = local.primary_bucket_name

  tags = {
    Name    = local.primary_bucket_name
    Project = var.project_name
    Region  = var.primary_region
  }
}

resource "aws_s3_bucket" "replica" {
  provider = aws.secondary
  bucket   = local.replica_bucket_name

  tags = {
    Name    = local.replica_bucket_name
    Project = var.project_name
    Region  = var.secondary_region
  }
}

resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.replica.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  bucket = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.replica.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "primary" {
  bucket = aws_s3_bucket.primary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "replica" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.replica.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "replication" {
  name = "${var.project_name}-replication-role-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "replication" {
  name = "${var.project_name}-replication-policy-${random_id.suffix.hex}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.primary.arn
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.replica.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [
    aws_s3_bucket_versioning.primary,
    aws_s3_bucket_versioning.replica
  ]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.primary.id

  rule {
    id     = "replicate-all"
    status = "Enabled"

    filter {}

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Disabled"
    }
  }
}

# Optional cross-account example resources.
# Uncomment only if you actually configured the aliased assume_role providers.
#
# resource "aws_s3_bucket" "production_account" {
#   provider = aws.production
#   bucket   = "${var.project_name}-prod-${random_id.suffix.hex}"
# }
#
# resource "aws_s3_bucket" "staging_account" {
#   provider = aws.staging
#   bucket   = "${var.project_name}-staging-${random_id.suffix.hex}"
# }