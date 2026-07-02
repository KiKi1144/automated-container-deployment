terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-1"
  shared_config_files      = []
  shared_credentials_files = []
}

# Security Group - This is the main addition
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow SSH and HTTP traffic for the Docker app"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Access (for your web application)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_project_server" {
  ami                    = "ami-0c1c30571d2dae5c9"
  instance_type          = "t3.micro"
  key_name               = "Cloud-Infrastructure-Key"
  
  # Attach Security Group
  security_groups        = [aws_security_group.allow_web.name]

  tags = {
    Name = "Terraform-Ubuntu-Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.my_project_server.public_ip
}
