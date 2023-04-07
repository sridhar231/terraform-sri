region = "us-west-2"
ntier_vpc_info = {
  subnet_azs      = ["a", "b", "a", "b", "a", "b"]
  subnet_names    = ["web1", "web2", "app1", "app2", "db1", "db2"]
  vpc_cidr        = "192.168.0.0/16"
  public_subnets  = ["web1", "web2"]
  private_subnets = ["app1", "app2", "db1", "db2"]
  ec2_subnet      = "web1"
}