output "AWS_Secret_Engine_Output" {
  value = <<README

EC2 Instance IP: ${aws_instance.instance.public_ip}

ssh -i awskey.pem ec2-user@${aws_instance.instance.public_ip}

AWS Keys used by Terraform to provision Instances:
Access Key: ${data.vault_aws_access_credentials.creds.access_key}
Secret Key: ${data.vault_aws_access_credentials.creds.secret_key}
README
}
