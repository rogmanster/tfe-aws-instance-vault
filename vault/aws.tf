#AWS Secret Engine
resource "vault_aws_secret_backend" "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_DEFAULT_REGION
  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "300"
}

resource "vault_aws_secret_backend_role" "role" {
  backend = vault_aws_secret_backend.aws.path
  name    = "deploy"
  credential_type = "iam_user"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "iam:GetUser"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOT
}
