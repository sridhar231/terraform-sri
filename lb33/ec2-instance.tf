data "aws_subnet" "ec2" {
  filter {
    name   = "tag:Name"
    values = [var.ntier_vpc_info.ec2_subnet]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.ntier.id]
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

resource "aws_security_group" "ec2-sg" {
  vpc_id = aws_vpc.ntier.id
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "Tcp"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "Tcp"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "Tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
  tags = {
    Name = "ec2-sg"
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

data "aws_ami_ids" "Ubuntu" {
  owners = ["099720109477"]
  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-03-25"]
  }
  filter {
    name   = "is-public"
    values = ["true"]
  }
}

resource "aws_instance" "Apache2" {
  ami                         = data.aws_ami_ids.Ubuntu.ids[0]
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.ec2.id
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  user_data                   = filebase64("apache2.sh")
  key_name                    = "keykey"
  tags = {
    Name = "Apache2"
  }
  depends_on = [
    aws_security_group.ec2-sg,
    aws_subnet.subnets
  ]
}

