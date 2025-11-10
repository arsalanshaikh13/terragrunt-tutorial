terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
#   backend  "s3"{
#     bucket         = "s3-backend-tutorial-terragrunt"
#     key            = "tutorial/network.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "dynanmo-state-lock"
#     encrypt        = true
#     use_lockfile   = true
#   }
# }

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
#  export AWS_ACCESS_KEY_ID="anaccesskey"
#  export AWS_SECRET_ACCESS_KEY="asecretkey"
#  set AWS_ACCESS_KEY_ID="anaccesskey"
#  set AWS_SECRET_ACCESS_KEY="asecretkey"



# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Tutorial VPC"
  }
}
# subnets
resource "aws_subnet" "public-subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  #   availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  #   availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-1"
  }
}
# internet and nat gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

# resource "aws_eip" "nat-eip" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat-gw" {
#   allocation_id = aws_eip.nat-eip.id
#   subnet_id     = aws_subnet.private-subnet2.id

#   tags = {
#     Name = "gw-NAT"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.main-igw]
# }
# route tables
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main_vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "public-rtb"
  }

}


resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main_vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_nat_gateway.nat-gw.id
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "private-rtb"
  }

}

# Route Table association
resource "aws_route_table_association" "public-rtb-assoc" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "private-rtb-assoc" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-rtb.id
}

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

