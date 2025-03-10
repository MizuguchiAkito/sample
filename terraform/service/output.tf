resource "aws_ssm_parameter" "secret_manager_name" {
  name  = "/${var.prefix_name}/${var.environment}/backend/secret_manager_name"
  type  = "String"
  value = aws_secretsmanager_secret.backend.name
}

output "secret_manager_name_param" {
  value = aws_ssm_parameter.secret_manager_name.name
}

resource "aws_ssm_parameter" "lambda_ecr_url" {
  name  = "/${var.prefix_name}/${var.environment}/backend/ecr/lambda"
  type  = "String"
  value = aws_ecr_repository.lambda.repository_url
}

output "lambda_ecr_url_param" {
  value = aws_ssm_parameter.lambda_ecr_url.name
}

output "lambda_ecr_url" {
  value = aws_ecr_repository.lambda.repository_url
}
