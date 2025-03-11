

output "alb_dns_name" {
  value = module.network.alb_dns_name
}

output "frontend_ecr_url" {
  value = module.storage.frontend_ecr_url
}

output "backend_ecr_url" {
  value = module.storage.backend_ecr_url
}
