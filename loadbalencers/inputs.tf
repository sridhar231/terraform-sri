variable "region" {
  type    = string
  default = "us-east-1"

}
variable "sri_vpc_info" {
  type = object({
    vpc_cidr    = string
    subnet_names = list(string)
    cidr_block  = string
    subnet_azs  = list(string)
  })
  default = {
    vpc_cidr    = "192.168.0.0/16"
    subnet_names = ["web1", "web2", "app1", "app2", "db1", "db2"]
    cidr_block  = "192.168.0.0/16"
    subnet_azs  = ["a", "b", "a", "b", "a", "b"]
  }
}

