# ECR Repository for Angular Frontend
resource "aws_ecr_repository" "frontend_repo" {
  name = "angular-frontend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECR Repository for Angular Backend
resource "aws_ecr_repository" "backend_repo" {
  name = "angular-backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Outputs for ECR URLs
output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend_repo.repository_url
}

output "backend_ecr_url" {
  value = aws_ecr_repository.backend_repo.repository_url
}

