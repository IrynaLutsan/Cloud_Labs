resource "aws_ecr_repository" "app_repo" {
  name                 = "cloud-labs-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

output "ecr_repository_url" {
  description = "URL створеного ECR репозиторію"
  value       = aws_ecr_repository.app_repo.repository_url
}