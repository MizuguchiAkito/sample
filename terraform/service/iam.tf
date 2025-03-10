data "aws_iam_policy" "power_user" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy" "iam_fuli_access" {
  arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role" "github_oidc" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_owner}/${var.github_repo}:*"
          ]
        }
      }
    }
  })
  name = "${var.prefix_name}-github-oidc"
}

resource "aws_iam_role_policy_attachment" "power_user" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = data.aws_iam_policy.power_user.arn
}

resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = data.aws_iam_policy.iam_fuli_access.arn
}