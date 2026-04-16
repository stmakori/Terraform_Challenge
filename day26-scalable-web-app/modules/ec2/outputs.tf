output "launch_template_id" {
  value = aws_launch_template.web.id
}

output "launch_template_version" {
  value = aws_launch_template.web.latest_version
}
