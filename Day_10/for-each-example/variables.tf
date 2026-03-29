variable "user_names" {
  type    = set(string)
  default = ["alice", "bob", "charlie"]
}

variable "users" {
  type = map(object({
    department = string
    admin      = bool
  }))

  default = {
    diana = {
      department = "engineering"
      admin      = true
    }
    evelyn = {
      department = "marketing"
      admin      = false
    }
  }
}