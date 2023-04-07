resource "aws_vpc" "sri" {
  cidr_block = var.sri_vpc_info.vpc_cidr
  tags = {
    Name = "sri"
  }
}

resource "aws_subnet" "sss" {
  count             = length(var.sri_vpc_info.subnet_names)
  vpc_id            = aws_vpc.sri.id
  availability_zone = "${var.region}${var.sri_vpc_info.subnet_azs[count.index]}"
  cidr_block        = cidrsubnet(var.sri_vpc_info.vpc_cidr, 8, count.index)
  depends_on = [
    aws_vpc.sri
  ]
  tags = {
    Name = var.sri_vpc_info.subnet_names[count.index]
  }
}

resource "aws_internet_gateway" "sri_igw" {
  vpc_id = aws_vpc.sri.id
  tags = {
    Name = "sri_igw"
  }
  depends_on = [
    aws_vpc.sri
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.sri.id
  tags = {
    Name = "private"
  }
  depends_on = [
    aws_subnet.sss
  ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.sri.id
  tags = {
    Name = "public"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sri_igw.id
  }
  depends_on = [
    aws_subnet.sss
  ]
}

data "aws_subnets" "public" {

  filter {
    name   = "tag:Name"
    values = var.sri_vpc_info.public_subnets
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.sri.id]
  }
  depends_on = [
    aws_subnet.sss
  ]
}


data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = var.sri_vpc_info.private_subnets
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.sri.id]
  }
  depends_on = [
    aws_subnet.sss
  ]
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.sri_vpc_info.private_subnets)
  subnet_id      = data.aws_subnets.private.ids[count.index]
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_vpc.sri,
    aws_subnet.sss
  ]
}
#route_table_association
resource "aws_route_table_association" "public_association" {
  count          = length(var.sri_vpc_info.public_subnets)
  subnet_id      = data.aws_subnets.public.ids[count.index]
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_vpc.sri,
    aws_subnet.sss
  ]
}