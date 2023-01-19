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