terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  backend "s3" {
    key    = "aws/Devinis-store/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
}

# Provision the ec2 instance for Devinis-server
resource "aws_instance" "Devinis-server" {
  ami                    = "ami-0aa2b7722dc1b5612"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.general-sg.id]

  tags = {
    "Name" = "Devinis-server"
  }
}

# Provision the ec2 instance for Devinis-client
resource "aws_instance" "Devinis-client" {
  ami                    = "ami-0aa2b7722dc1b5612"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.general-sg.id]

  tags = {
    "Name" = "Devinis-client"
  }
}
# Provision the security group
resource "aws_security_group" "general-sg" {
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow ssh"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "allow http"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
  }]
}
output "Devinis-sever_public_ip" {
  value     = aws_instance.Devinis-server.public_ip
  sensitive = true
}

output "Devinis-client_public_ip" {
  value     = aws_instance.Devinis-client.public_ip
  sensitive = true
}
