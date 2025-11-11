data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}


output "availability_zone_names" {
  value = data.aws_availability_zones.available.names
}
output "app_subnet_id" {
  value = aws_subnet.public-subnet1.id
}
