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