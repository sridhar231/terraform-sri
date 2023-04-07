resource "aws_vpc" "ntier" {
  cidr_block = var.ntier_vpc_info.vpc_cidr
  tags = {
    Name = "ntier"
  }
}

resource "aws_subnet" "subnets" {
  count             = length(var.ntier_vpc_info.subnet_names)
  cidr_block        = cidrsubnet(var.ntier_vpc_info.vpc_cidr, 8, count.index)
  availability_zone = "${var.region}${var.ntier_vpc_info.subnet_azs[count.index]}"
  vpc_id            = aws_vpc.ntier.id
  tags = {
    Name = var.ntier_vpc_info.subnet_names[count.index]
  }
  depends_on = [
    aws_vpc.ntier
  ]
}

resource "aws_internet_gateway" "ntier-igw" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "ntier-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ntier.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ntier-igw.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "private"
  }

}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.ntier_vpc_info.public_subnets
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.ntier.id]
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = var.ntier_vpc_info.private_subnets
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.ntier.id]
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

resource "aws_route_table_association" "public_associations" {
  count          = length(var.ntier_vpc_info.public_subnets)
  subnet_id      = data.aws_subnets.public.ids[count.index]
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_vpc.ntier,
    aws_subnet.subnets
  ]
}

resource "aws_route_table_association" "private_associations" {
  count          = length(var.ntier_vpc_info.private_subnets)
  subnet_id      = data.aws_subnets.private.ids[count.index]
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_vpc.ntier,
    aws_subnet.subnets
  ]
}

