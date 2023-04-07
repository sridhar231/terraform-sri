# creating variable for region
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

# creating input variables for vpc
variable "aws_vpc_range" {
  type    = string
  default = "192.168.0.0/16"
}

## variable for subnets
variable "aws_subnet_app1_cidr" {
  type    = string
  default = "192.168.0.0/24"
}
variable "aws_subnet_app2_cidr" {
  type    = string
  default = "192.168.1.0/24"

}
variable "aws_subnet_db1_cidr" {
  type    = string
  default = "192.168.2.0/24"

}
variable "aws_subnet_db2_cidr" {
  type    = string
  default = "192.168.3.0/24"

}
