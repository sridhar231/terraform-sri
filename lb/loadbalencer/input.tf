variable "region" {
  type    = string
  default = "us-east-1"
}

variable "sri_vpc_info" {
  type = object({
    vpc_cidr        = string
    subnet_names    = list(string),
    subnet_azs      = list(string),
    private_subnets = list(string),
    public_subnets  = list(string),
    db_subnets      = list(string),
    web_ec2_subnet  = string
  })
  default = {
    vpc_cidr        = "192.168.0.0/16"
    subnet_names    = ["web1", "web2", ]
    subnet_azs      = ["a", "b"]
    private_subnets = []
    public_subnets  = ["web1", "web2"]
    db_subnets      = []
    web_ec2_subnet  = "web1"

  }

}

