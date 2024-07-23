provider "aws" {
  region = "eu-central-1"
}


terraform {
  backend "s3" {
    bucket = "123terrabucket123"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "volume_size" {
  description = "EBS volume size in GB"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp2"
}

variable "ami" {
  description = "AMI ID"
  type        = string
  default     = ""
}

variable "ssh_key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "docker-compose3"
}

variable "security_group_rules" {
  description = "List of security group rules"
  type = list(object({
    from_port  = number
    to_port    = number
    protocol  = string
    description = string
    cidr_blocks = list(string) # Change to list(string)
  }))
  default = [
    {
      from_port  = 22
      to_port    = 22
      protocol  = "tcp"
      description = "SSH from 0.0.0.0/0"
      cidr_blocks = ["0.0.0.0/0"] # Change to a list containing the CIDR block
    },
    {
      from_port  = 80
      to_port    = 80
      protocol  = "tcp"
      description = "HTTP"
      cidr_blocks = ["0.0.0.0/0"] # Change to a list containing the CIDR block
    }
  ]
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id            = "vpc-04347ab37cb8133ff"
  cidr_block         = "172.31.10.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "EC2 Security Group"
  vpc_id            = "vpc-04347ab37cb8133ff"
  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol   = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks # Access directly from the object
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
