resource "aws_vpc" "sri" {
  cidr_block = var.sri_vpc_info.vpc_cidr
  tags = {
    Name = "sri"
  }
}
resource "aws_subnet" "sss" {
  vpc_id            = aws_vpc.sri.id
  count             = length(var.sri_vpc_info.subnet_names)
  cidr_block        = cidrsubnet(var.sri_vpc_info.vpc_cidr, 8, count.index)
  availability_zone = "${var.region}${var.sri_vpc_info.subnet_azs[count.index]}"
  tags = {
    Name = var.sri_vpc_info.subnet_names[count.index]
  }
  depends_on = [
  aws_vpc.sri
  ]
}


           