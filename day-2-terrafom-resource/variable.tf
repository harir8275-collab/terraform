variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  default = "ami_id"
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}