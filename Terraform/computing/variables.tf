variable "vpc_id" {
  description = "VPC ID where instances will be deployed"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "private_subnet1_id" {
  description = "First private subnet ID"
  type        = string
}

variable "tg_http_arn" {
  description = "Target Group ARN for HTTP"
  type        = string
}
