variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "DEFAULTVPC"
}

variable "three_ec2s" {
  type = list(string)
  description = "values for the three ec2s"
  default = ["one", "two", "three"]
}