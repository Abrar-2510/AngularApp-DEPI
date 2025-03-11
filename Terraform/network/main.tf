# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway for Public Access
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
}

# Public Subnets (Across Different AZs)
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# Private Subnets (For App Servers in Different AZs)
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# Application Load Balancer
resource "aws_lb" "app_elb" {
  name               = "angular-app-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]  # Different AZs
}

# Target Group for Frontend
resource "aws_lb_target_group" "tg_http" {
  name     = "angular-http-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Target Group for Backend
resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 3200
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/metrics"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ALB Listener (Forwarding Traffic to Frontend)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_http.arn
  }
}

# ALB Listener Rule for Backend API Traffic
resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = ["angularapp.com"]
    }
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}





# Route 53 Zone (If Not Already Created)
resource "aws_route53_zone" "main" {
  name = "angularapp.com"  # Replace with your domain
}

# Route 53 Record for Frontend
resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "angularapp.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_elb.dns_name
    zone_id                = aws_lb.app_elb.zone_id
    evaluate_target_health = true
  }
}

# Route 53 Record for Backend API
resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.angularapp.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_elb.dns_name
    zone_id                = aws_lb.app_elb.zone_id
    evaluate_target_health = true
  }
}
