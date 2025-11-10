variable "vpc_cidr" {
  description = "vpc cidr range"
  # default = "10.100.0.0/16"
}
variable "public_subnet_cidr" {
  description = "vpc cidr range"
  # default = "10.100.1.0/24"
}
variable "private_subnet_cidr" {
  description = "vpc cidr range"
  # default = "10.100.3.0/24"
}
# variable "bucket_name" {
#   description = "tf state backend s3"
# }
# # variable "dynamodb_table" {
# #     description = "tf state lock dynamodb table"
# # }
variable "region" {
  description = "region for the network"
}