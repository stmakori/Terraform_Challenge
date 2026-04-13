resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.instance_type

  user_data = file("${path.module}/user_data.sh")

  tags = merge(var.tags, {
    Name = "day22-webserver"
  })
}
