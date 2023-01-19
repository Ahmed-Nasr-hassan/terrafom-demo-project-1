data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}


resource "aws_security_group" "nasrsg" {
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.nasr-vpc.id

  ingress {
    description      = "SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.allow_all_ipv4_cidr_blocks]
    ipv6_cidr_blocks = [var.allow_all_ipv6_cidr_blocks]
  }

  ingress {
    description      = "HTTP from Anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.allow_all_ipv4_cidr_blocks]
    ipv6_cidr_blocks = [var.allow_all_ipv6_cidr_blocks]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.allow_all_ipv4_cidr_blocks]
    ipv6_cidr_blocks = [var.allow_all_ipv6_cidr_blocks]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}




