# Region
# configure the provider
provider "aws" {
    region = var.region
}

# EC2 
resource "aws_instance" "web" {
    count = var.instance_count
    subnet_id = var.app_subnet_id
    ami = var.image_type
    instance_type = var.instance_types
    tags = {
      Name = "EC2-0${count.index + 1}"
    }
}
