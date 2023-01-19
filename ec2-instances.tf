resource "aws_instance" "nasr-ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.nasr-subnet[count.index].id
  associate_public_ip_address = var.associate_public_ip_address[count.index]
  vpc_security_group_ids = [aws_security_group.nasrsg.id]
  count=2
  user_data = var.apache-user-data
}

