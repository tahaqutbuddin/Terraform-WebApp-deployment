resource "aws_instance" "dummy-server" {
    ami = "ami-02396cdd13e9a1257"
    instance_type = "t2.micro"
    tags = {
        name = "Your-DevOps-Mentor-tutorial"
    }
}