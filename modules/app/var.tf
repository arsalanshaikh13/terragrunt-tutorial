variable "region" {
    description = "Region Selection" 
}

variable "instance_count" {
    description = "Number of Ec2 Instances"
    type = number
    default = 1
}

variable "instance_types" {
  description = "Instance type"
  default = "t4g.small"
}

variable "image_type" {
  description = "Image type"
  default = "ami-03f05f1a97033e6dc"
}

variable "app_subnet_id" {
  type = string
}