variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "environment" {}
variable "region" {}
variable "tags" {
  type    = map(string)
  default = {}
}
