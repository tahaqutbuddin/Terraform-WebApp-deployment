# Launch Template Resource
resource "aws_launch_template" "asg_lt" {
  name_prefix   = "${var.env_code}-LT"
  description   = "My Launch Template"
  image_id      = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type
  key_name      = var.key_pair
  user_data     = filebase64("user-data.sh")

  network_interfaces {
    associate_public_ip_address = true
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env_code}-ASG-Template"
    }
  }
}


resource "aws_autoscaling_group" "main" {
  name                      = "${var.env_code}-ASG"
  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = data.terraform_remote_state.level1.outputs.public_subnet_id

  target_group_arns = [aws_lb_target_group.main.arn]


  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }
}