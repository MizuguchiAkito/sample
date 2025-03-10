resource "aws_secretsmanager_secret" "backend" {
  name = "${var.prefix_name}-backend-secret"
  tags = {
    "Name" = "${var.prefix_name}-backend-secret"
  }
}

# 初期値を入れておく(入れないと読み取り時にエラーが出てしまう為)
resource "aws_secretsmanager_secret_version" "initial" {
  secret_id     = aws_secretsmanager_secret.backend.id
  secret_string = jsonencode({})
}
