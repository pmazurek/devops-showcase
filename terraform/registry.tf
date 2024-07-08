resource "aws_ecr_repository" "frontend_app" {
  name                 = "frontend_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend_app" {
  name                 = "backend_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_frontend_repo" {
  value = "${aws_ecr_repository.frontend_app.repository_url}"
}
output "ecr_backend_repo" {
  value = "${aws_ecr_repository.backend_app.repository_url}"
}
