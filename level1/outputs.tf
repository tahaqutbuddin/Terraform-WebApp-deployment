// This code is written to export referened resources from level1 and then any other level files can easily use them
output "public_subnet_id" {
  value = aws_subnet.public[*].id
}
output "private_subnet_id" {
  value = aws_subnet.private[*].id
}
output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}