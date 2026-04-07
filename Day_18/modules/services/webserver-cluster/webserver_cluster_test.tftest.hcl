variables {
  cluster_name  = "test-cluster"
  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 2
  vpc_id        = "vpc-0123456789abcdef0"
  subnet_ids    = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  environment   = "dev"
}

run "validate_cluster_name" {
  command = plan

  assert {
    condition     = aws_autoscaling_group.example.name_prefix == "test-cluster-"
    error_message = "ASG name prefix must match cluster_name"
  }
}

run "validate_instance_type" {
  command = plan

  assert {
    condition     = aws_launch_configuration.example.instance_type == "t2.micro"
    error_message = "Instance type mismatch"
  }
}

run "validate_security_group_port" {
  command = plan

  assert {
    condition     = contains([for rule in aws_security_group.instance.ingress : rule.from_port], 8080)
    error_message = "Port 8080 must be open"
  }
}