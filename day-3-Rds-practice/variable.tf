variable "db_name" {
  default = "myappdb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default   = "MyPassword123!"
  sensitive = true
}