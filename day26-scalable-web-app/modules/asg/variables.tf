variable "launch_template_id" {}
variable "launch_template_version" {}

variable "public_subnet_ids" {
  type = list(string)
}

variable "target_group_arns" {
  type = list(string)
}
