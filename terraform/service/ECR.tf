resource "aws_ecr_repository" "lambda" {
  name = "${var.prefix_name}-lambda-repository-${var.environment}"

  # ECR内にimageが残っていても削除するようにする
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
