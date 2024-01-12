# configured aws provider with proper credentials
provider "aws" {
  region    = "ap-southeast-1"
  access_key = ""
  secret_key = ""
}


# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags    = {
    Name  = "Name Project use VPC"
  }
}


# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-southeast-1"

  tags   = {
    Name = "Default subnet for ap-southeast-1"
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 80 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["49.49.250.21/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ec2_security_group"
  }
}

# launch the ec2 instance and install website
resource "aws_instance" "ec2_instance" {
  ami                    = "" #use in ami in ec2
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "MyKeyPair"

  tags = {
    Name = "MyApp"
  }
}


# print the ec2's public ipv4 address
output "public_ipv4_address" {
  value = aws_instance.ec2_instance.public_ip
}