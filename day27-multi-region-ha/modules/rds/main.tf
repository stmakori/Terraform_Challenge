resource "aws_db_instance" "this" {
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20

  db_name             = "appdb"
  username            = "admin"
  password            = var.db_password

  multi_az            = true
  skip_final_snapshot = true
}
