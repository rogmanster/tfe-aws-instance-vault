terraform {
  required_version = ">= 0.12.0"
}

data "aws_ami" "rhel_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["*RHEL-7.3_HVM_GA-*"]
  }
}

#Generate Dynamic IAM creds
data "vault_aws_access_credentials" "creds" {
  backend = var.path
  role    = var.role_name
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  region = var.aws_region
  profile = var.aws_profile
}

resource "random_id" "name" {
  byte_length = 4
}

resource "aws_key_pair" "awskey" {
  key_name   = "awskwy-${random_id.name.hex}"
  public_key = tls_private_key.awskey.public_key_openssh
}

resource "aws_security_group" "allow_all" {
  name        = "allow-all-${random_id.name.hex}"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami               = data.aws_ami.rhel_ami.id
  instance_type     = var.instance_type
  availability_zone = "${var.aws_region}a"
  key_name          = aws_key_pair.awskey.key_name
  security_groups   = [aws_security_group.allow_all.name]

  tags = {
    Name        = var.name
    TTL         = var.ttl
    Owner       = var.owner
    Description = "This branch updated v5 - test"
  }
}

