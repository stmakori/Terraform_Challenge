output "vpc_id" {
  value = aws_vpc.example.id
}

output "private_subnet_ids" {
  value = aws_subnet.public[*].id
}