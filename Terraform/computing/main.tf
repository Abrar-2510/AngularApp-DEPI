# Security Group for EC2 Instances
resource "aws_security_group" "app_sg" {
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_alb_to_ec2" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = var.alb_sg_id
}

# EC2 Instance for Angular App
resource "aws_instance" "app_server" {
  ami             = "ami-052efd3df9dad4825"
  instance_type   = "t3.micro"
  subnet_id       = var.private_subnet1_id
  security_groups = [aws_security_group.app_sg.id]
  user_data       = <<-EOF
              #!/bin/bash
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              docker run -d -p 80:80 YOUR_ECR_IMAGE
          EOF
}

# Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = var.tg_http_arn
  target_id        = aws_instance.app_server.id
  port            = 80
}
