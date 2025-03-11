output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_elb.dns_name
}

output "frontend_domain" {
  description = "Frontend application domain"
  value       = aws_route53_record.frontend.name
}

output "backend_domain" {
  description = "Backend API domain"
  value       = aws_route53_record.backend.name
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "private_subnet1_id" {
  value = aws_subnet.private_subnet1.id
}

output "tg_http_arn" {
  value = aws_lb_target_group.tg_http.arn
}
