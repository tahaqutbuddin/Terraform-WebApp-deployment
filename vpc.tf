# locals {
#   availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
# }


# dynamically fetches availability zones for current region
data "aws_availability_zones" "available" {
  state = "available"
}


# For printing out values on Console
# output count {
#   value = length(var.public_cidr)
# }

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.env_code
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidr) // count will create public subnets iteratively
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr[count.index] //count.index will generate indexes 0,1
  

  # availability_zone = local.availability_zone[count.index]   // hardcoded method using local
  availability_zone = data.aws_availability_zones.available.names[count.index]  #dynamically assigns AZ
  
  tags = {
    Name = "Public${count.index + 1}-${var.env_code}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Private${count.index + 1}-${var.env_code}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-${var.env_code}"
  }
}

resource "aws_route_table" "mainRT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-${var.env_code}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.mainRT.id
}


// PAID Services Code below, 
// Variables for naming convention not set below code.


/*
resource "aws_eip" "nat" {
  count = length(var.public_cidr)
  vpc      = true
  tags = {
    Name = "nat${count.index+1}"
  }
}

resource "aws_nat_gateway" "natTable" {
  count = length(var.public_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id  //nat always placed in public subnet

  tags = {
    Name = "natTable${count.index+1}"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "privateRT" {
  count = length(var.private_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natTable[count.index].id
  }

  tags = {
    Name = "privateRT${count.index+1}"
  }
}


resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privateRT[count.index].id
}



*/