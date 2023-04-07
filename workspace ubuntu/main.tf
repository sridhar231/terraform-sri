resource "aws_vpc" "sri" {
  cidr_block = var.cidr-block
  tags = {
    Name = "sri-${terraform.workspace}"
    Env  = terraform.workspace
  }
}

resource "aws_subnet" "main" {
  count      = terraform.workspace == "qa" ? 1 : 0
  vpc_id     = aws_vpc.ntier.id
  cidr_block = "198.168.0.0/24"
}


