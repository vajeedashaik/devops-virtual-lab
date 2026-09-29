terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "devops_lab_sg" {
  name        = "devops-lab-sg"
  description = "Security group for DevOps Virtual Lab"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from my current IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["122.167.102.188/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps-Lab-SG"
  }
}

resource "aws_instance" "devops_server" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.devops_lab_sg.id]

  tags = {
    Name = "DevOps-Lab-Server"
  }
}
