#Provide Data source to fetch AMI
data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazonlinux.id // fetches AMI dynmically using data source
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.public.id]
  # subnet_id                   = aws_subnet.public[0].id
  //when vpc is in different level directory, then output from there, and use data source to import it like this over here
  subnet_id = data.terraform_remote_state.level1.outputs.public_subnet_id[0]

  key_name  = "terraform-practice"
  user_data = file("user-data.sh")
  tags = {
    Name = "Public-${var.env_code}"
  }

}

resource "aws_security_group" "public" {
  name        = "Public-${var.env_code}"
  description = "Allow inbound traffic"
  # vpc_id      = aws_vpc.main.id
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    description = "SSH"
    protocol    = "tcp"
    cidr_blocks = ["137.59.218.15/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    description = "HTTP for public"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    description = "Allow All outbound traffic"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_code}-SG-pub"
  }
}

resource "aws_instance" "private" {
  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.private.id]
  # subnet_id              = aws_subnet.private[0].id
  //when vpc is in different level directory, then output from there, and use data source to import it like this over here
  subnet_id = data.terraform_remote_state.level1.outputs.private_subnet_id[0]

  key_name = "terraform-practice"
  tags = {
    Name = "Private-${var.env_code}"
  }

}

resource "aws_security_group" "private" {
  name        = "Private-${var.env_code}"
  description = "Allow VPC traffic"
  # vpc_id      = aws_vpc.main.id
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    description = "SSH"
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.level1.outputs.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    description = "Allow All outbound traffic"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_code}-SG-pvt"
  }
}

