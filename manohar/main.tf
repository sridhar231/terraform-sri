## creating vpc
resource "aws_vpc" "lb_vpc" {
  cidr_block = var.lb_vpc_info.lb_vpc_cidr
  tags = {
    Name = "lb_vpc"
  }
}
## creating subnet
resource "aws_subnet" "lb_subnet" {
  count             = length(var.lb_vpc_info.lb_subnet_names)
  vpc_id            = aws_vpc.lb_vpc.id
  cidr_block        = cidrsubnet(var.lb_vpc_info.lb_vpc_cidr, 8, count.index)
  availability_zone = "${var.region}${var.lb_vpc_info.lb_subnets_names_azs[count.index]}"
  tags = {
    Name = var.lb_vpc_info.lb_subnet_names[count.index]
  }
  depends_on = [
    aws_vpc.lb_vpc
  ]

}
## creating internetgate_way
resource "aws_internet_gateway" "igw_lb" {
  vpc_id = aws_vpc.lb_vpc.id
  tags = {
    Name = "igw_lb"
  }
  depends_on = [
    aws_vpc.lb_vpc
  ]
}
## creating route_table
resource "aws_route_table" "route_table_lb" {
  vpc_id = aws_vpc.lb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_lb.id
  }
  tags = {
    Name = "igw_lb"
  }
  depends_on = [
    aws_internet_gateway.igw_lb
  ]
}
## creating route_table association
resource "aws_route_table_association" "lb_main_rt_association" {
  count          = 1
  subnet_id      = aws_subnet.lb_subnet[count.index].id
  route_table_id = aws_route_table.route_table_lb.id
  depends_on = [
    aws_route_table.route_table_lb
  ]

}
## create security group
resource "aws_security_group" "terraformlb" {
  name        = "terraformlb"
  vpc_id      = aws_vpc.lb_vpc.id
  description = "allow all ports"
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "Tcp"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "Tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  depends_on = [
    aws_subnet.lb_subnet
  ]
}
## create keypair
resource "aws_key_pair" "newone" {
  key_name   = "terraform3"
  public_key = file("~/.ssh/id_rsa.pub")
}
## create EC2 instance
resource "aws_instance" "lb" {
  count                       = 1
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  ami                         = "ami-007855ac798b5175e"
  subnet_id                   = aws_subnet.lb_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.terraformlb.id]
  key_name                    = "terraform3"
  user_data                   = filebase64("apache.sh")
  tags = {
    Name = "lb"
  }
  depends_on = [
    aws_security_group.terraformlb
  ]
}
## create target group
resource "aws_lb_target_group" "tg" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.lb_vpc.id
}


## create target group attachement
resource "aws_lb_target_group_attachment" "tg-attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.lb[count.index].id
  port             = 80
}
## create load balancer
resource "aws_lb" "lb1" {
  name               = "lb1-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraformlb.id]
  subnets            = [for subnet in aws_subnet.lb_subnet : subnet.id]

  enable_deletion_protection = true
  tags = {
    Environment = "production"
  }
}