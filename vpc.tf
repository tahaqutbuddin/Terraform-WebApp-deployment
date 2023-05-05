locals {
  public_cidr = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
  private_cidr = ["10.0.100.0/24","10.0.101.0/24","10.0.102.0/24"]
  availability_zone = ["us-east-1a","us-east-1b","us-east-1c"]
}

# For printing out values on Console
# output count {
#   value = length(local.public_cidr)
# }

resource "aws_vpc" "main"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Your-DevOps-Mentor-Tutorial"
    }
} 

resource "aws_subnet" "public" {
  count = length(local.public_cidr)         // count will create public subnets iteratively
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_cidr[count.index]     //count.index will generate indexes 0,1
  availability_zone = local.availability_zone[count.index]
  tags = {
    Name = "Public${ count.index+1 }-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_subnet" "private" {
  count = length(local.private_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_cidr[count.index]
  availability_zone = local.availability_zone[count.index]
  tags = {
    Name = "Private${ count.index+1 }-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_route_table" "mainRT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_route_table_association" "public" {
  count = length(local.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.mainRT.id
}


// PAID Services Code below
/*
resource "aws_eip" "nat" {
  count = length(local.public_cidr)
  vpc      = true
  tags = {
    Name = "nat${count.index+1}"
  }
}

resource "aws_nat_gateway" "natTable" {
  count = length(local.public_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id  //nat always placed in public subnet

  tags = {
    Name = "natTable${count.index+1}"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "privateRT" {
  count = length(local.private_cidr)
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
  count = length(local.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privateRT[count.index].id
}



*/