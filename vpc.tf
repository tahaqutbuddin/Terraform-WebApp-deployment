resource "aws_vpc" "main"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Your-DevOps-Mentor-Tutorial"
    }
} 

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public1-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private1-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public2-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private2-Your-DevOps-Mentor-Tutorial"
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

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.mainRT.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.mainRT.id
}


// PAID Services Code below
/*
resource "aws_eip" "nat1" {
  vpc      = true
}
resource "aws_eip" "nat2" {
  vpc      = true
}

resource "aws_nat_gateway" "natTable1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id  //nat always placed in public subnet

  tags = {
    Name = "NAT1-Your-DevOps-Mentor-Tutorial"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natTable2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public2.id 

  tags = {
    Name = "NAT2-Your-DevOps-Mentor-Tutorial"
  }
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "privateRT1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natTable1.id
  }

  tags = {
    Name = "privateRT1-Your-DevOps-Mentor-Tutorial"
  }
}


resource "aws_route_table" "privateRT2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.natTable2.id
  }

  tags = {
    Name = "privateRT2-Your-DevOps-Mentor-Tutorial"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.privateRT1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.privateRT2.id
}


*/