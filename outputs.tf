output "AWS_Secret_Engine_Output" {
  value = <<README

EC2 Instance IP: ${module.instance.public_ip}

ssh -i awskey.pem ec2-user@${module.instance.public_ip}

AWS Keys used by Terraform to provision Instances:
Access Key: ${module.instance.access_key}
Secret Key: ${module.instance.secret_key}
README
}
