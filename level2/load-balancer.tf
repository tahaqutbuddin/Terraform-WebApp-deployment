//Need its own security group
resource "aws_security_group" "load_balancer" {
  name        = "${var.env_code}-load-balancer"
  description = "Allow port 80 TCP inbound to ELB"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    description = "HTTP for ELB"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_code}-load-balancer"
  }
}

resource "aws_lb" "main" {
  name = var.env_code


  #   internal           = false            //internal means available only within the VPC itself
  #   default is false

  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]

  subnets = data.terraform_remote_state.level1.outputs.public_subnet_id


  tags = {
    Name = var.env_code
  }
}

resource "aws_lb_target_group" "main" {
  name     = var.env_code
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.level1.outputs.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }
}


//NOT Needed because of ASG

# resource "aws_lb_target_group_attachment" "main" {
#   count            = 2
#   target_group_arn = aws_lb_target_group.main.arn
#   target_id        = aws_instance.public[count.index].id
#   port             = 80

# }

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

}

