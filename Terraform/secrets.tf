# ------------- create aws secret manager --------------------------

resource "aws_secretsmanager_secret" "my_secret" {
  name                    = "my_secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = tls_private_key.my_key.private_key_pem

}
