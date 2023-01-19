output "public_ip_of_public_ec2" {
  value = aws_instance.nasr-ec2[0].public_ip
}

output "private_ip_of_private_ec2" {
  value = aws_instance.nasr-ec2[1].private_ip
}

