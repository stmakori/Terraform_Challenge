variable "ami_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "subnet_ids" {
  type = list(string)
}
variable "target_group_arns" {
  type = list(string)
}
variable "alb_sg" {}
variable "vpc_id" {}
variable "environment" {}
variable "region" {}
