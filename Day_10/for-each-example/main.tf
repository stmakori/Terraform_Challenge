provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "set_users" {
  for_each = var.user_names
  name     = each.value
}

resource "aws_iam_user" "map_users" {
  for_each = var.users
  name     = each.key

  tags = {
    Department = each.value.department
    Admin      = tostring(each.value.admin)
  }
}

output "set_user_arns" {
  value = { for name, user in aws_iam_user.set_users : name => user.arn }
}

output "map_user_arns" {
  value = { for name, user in aws_iam_user.map_users : name => user.arn }
}