variable "region" {
  type    = string
  default = "us-west-2"
}

variable "ntier_vpc_info" {
  type = object({
    subnet_names    = list(string)
    subnet_azs      = list(string)
    vpc_cidr        = string
    public_subnets  = list(string)
    private_subnets = list(string)
    ec2_subnet      = string
  })
  default = {
    subnet_azs      = ["a", "b", "a", "b", "a", "b"]
    subnet_names    = ["web1", "web2", "app1", "app2", "db1", "db2"]
    vpc_cidr        = "192.168.0.0/16"
    public_subnets  = []
    private_subnets = ["app1", "app2", "db1", "db2"]
    ec2_subnet      = "web1"
  }
}