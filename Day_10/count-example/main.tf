provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

output "count_user_names" {
  value = aws_iam_user.example[*].name
}