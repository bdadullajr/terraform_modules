variable "region" {
  description = "AWS region for hosting our your network"
  default     = "us-east-1"
}

variable "amis" {
  description = "Base AMI to launch the instances"

  default = {
    us-east-1 = "ami-0b898040803850657"
  }
}
