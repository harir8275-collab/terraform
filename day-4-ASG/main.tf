# Create Security Group
resource "aws_security_group" "my_sg" {
  name = "terraform-asg-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get default subnets
data "aws_subnets" "default" {}

# Launch Template
resource "aws_launch_template" "my_template" {
  name_prefix   = "my-template"
  image_id      = "ami-0a59ec92177ec3fad" # Amazon Linux 2 AMI in us-east-1
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.my_sg.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from Terraform ASG" > /var/www/html/index.html
EOF
)
}

# Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}