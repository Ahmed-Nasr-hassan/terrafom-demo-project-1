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
