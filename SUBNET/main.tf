resource "aws_vpc" "ntier" {
  cidr_block = var.aws_vpc_range
  tags = {
    Name = "ntier"
  }
}
resource "aws_subnet" "app1" {
  cidr_block        = var.aws_subnet_app1_cidr
  availability_zone = "${var.aws_region}a"
  vpc_id            = aws_vpc.ntier.id
  tags = {
    Name = "app1"
  }
}
resource "aws_subnet" "app2" {
  cidr_block        = var.aws_subnet_app2_cidr
  availability_zone = "${var.aws_region}b"
  vpc_id            = aws_vpc.ntier.id
  tags = {
    Name = "app2"
  }
}
resource "aws_subnet" "db1" {
  cidr_block        = var.aws_subnet_db1_cidr
  availability_zone = "${var.aws_region}a"
  vpc_id            = aws_vpc.ntier.id
  tags = {
    Name = "db1"
  }
}
resource "aws_subnet" "db2" {
  cidr_block        = var.aws_subnet_db2_cidr
  availability_zone = "${var.aws_region}b"
  vpc_id            = aws_vpc.ntier.id
  tags = {
    Name = "db2"
  }

}
