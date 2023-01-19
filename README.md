# terrafom-demo-project-1

## lab2

![Alt text](./lab2.png?raw=true "Title")

### vpc config

```bash
resource "aws_vpc" "nasr-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        "Name" : "terraform-vpc-lab2"
    }
}

resource "aws_subnet" "nasr-subnet" {
    vpc_id = aws_vpc.nasr-vpc.id
    cidr_block = var.subnet_cidr_blocks[count.index]
    count = length(var.subnet_cidr_blocks)
}

resource "aws_internet_gateway" "nasr-gateway" {
    vpc_id = aws_vpc.nasr-vpc.id
}

resource "aws_eip" "nasr-eip" {
  vpc = true
}

resource "aws_nat_gateway" "nasr-nat-gtw" {
  subnet_id     = aws_subnet.nasr-subnet[0].id
  allocation_id = aws_eip.nasr-eip.id
}

resource "aws_route_table" "nasr-route-table-public" {
    vpc_id = aws_vpc.nasr-vpc.id
    
  route {
    cidr_block = var.allow_all_ipv4_cidr_blocks
    gateway_id = aws_internet_gateway.nasr-gateway.id
  }

  route {
    ipv6_cidr_block        = var.allow_all_ipv6_cidr_blocks
    gateway_id = aws_internet_gateway.nasr-gateway.id
  }

}

resource "aws_route_table" "nasr-route-table-private" {
    vpc_id = aws_vpc.nasr-vpc.id
    
  route {
    cidr_block = var.allow_all_ipv4_cidr_blocks
    gateway_id = aws_nat_gateway.nasr-nat-gtw.id
  }
}

resource "aws_route_table_association" "rt-associate-public" {
  subnet_id      = aws_subnet.nasr-subnet[0].id
  route_table_id = aws_route_table.nasr-route-table-public.id
}

resource "aws_route_table_association" "rt-associate-private" {
  subnet_id      = aws_subnet.nasr-subnet[1].id
  route_table_id = aws_route_table.nasr-route-table-private.id
}
```

---

### ec2 config

```bash
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
```

---

### ec2 instance

```bash
resource "aws_instance" "nasr-ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.nasr-subnet[count.index].id
  associate_public_ip_address = var.associate_public_ip_address[count.index]
  vpc_security_group_ids = [aws_security_group.nasrsg.id]
  count=2
  user_data = var.apache-user-data
}
```

---

### variables

```bash
variable "vpc_cidr_block" {
  description = "vpc cidr block string ex. 10.0.0.0/16"
  type = string
}

variable "subnet_cidr_blocks" {
  description = "subnet cidr block list ex. [10.0.0.0/24,10.0.2.0/24]"
  type = list
}

variable "allow_all_ipv4_cidr_blocks" {
  type = string
}

variable "allow_all_ipv6_cidr_blocks" {
  type = string
}

variable "associate_public_ip_address" {
  type = list
}

variable "instance_type" {
  type = string
}

variable "apache-user-data" {

}
```

---

### inputs

```bash
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_blocks = ["10.0.0.0/24","10.0.1.0/24"]
allow_all_ipv4_cidr_blocks = "0.0.0.0/0"
allow_all_ipv6_cidr_blocks = "::/0"
associate_public_ip_address = [true,false]
instance_type = "t2.micro"
apache-user-data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
EOF
```

### outputs

```bash
output "public_ip_of_public_ec2" {
  value = aws_instance.nasr-ec2[0].public_ip
}

output "private_ip_of_private_ec2" {
  value = aws_instance.nasr-ec2[1].private_ip
}
```

---

## photos

### private instance review

![Alt text](./private%201.png?raw=true "Title")

---

![Alt text](./private%202.png?raw=true "Title")

### public instance review

![Alt text](./public%202.png?raw=true "Title")
