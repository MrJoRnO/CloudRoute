resource "aws_kms_key" "this" {
  description             = var.kms_key_description
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_secretsmanager_secret" "this" {
  name       = var.secret_name
  kms_key_id = aws_kms_key.this.arn
  tags       = var.tags
}

resource "aws_iam_policy" "read_secrets" {
  name        = "${var.secret_name}-read-policy"
  description = "Policy to allow reading the ${var.secret_name} secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.this.arn
      },
      {
        Effect   = "Allow"
        Action   = "kms:Decrypt"
        Resource = aws_kms_key.this.arn
      }
    ]
  })
}

output "secret_arn" {
  value = aws_secretsmanager_secret.this.arn
}

output "policy_arn" {
  value = aws_iam_policy.read_secrets.arn
}