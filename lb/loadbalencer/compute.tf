resource "aws_security_group" "web" {
  name = "web"
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "web"
  }
  vpc_id = aws_vpc.sri.id
  depends_on = [
    aws_subnet.sss
  ]
}

data "aws_ami_ids" "ubuntu_2204" {
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

data "aws_subnet" "web" {
  vpc_id = aws_vpc.sri.id
  filter {
    name   = "tag:Name"
    values = [var.sri_vpc_info.web_ec2_subnet]
  }

  depends_on = [
    aws_subnet.sss
  ]
}
resource "aws_key_pair" "mykey" {
  key_name   = "sri"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_instance" "web" {
  ami                         = data.aws_ami_ids.ubuntu_2204.ids[0]
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.web.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = "sri"
  user_data                   = filebase64("apache2.sh")
  tags = {
    Name = "web1"=
  }
  depends_on = [
    aws_security_group.web
  ]

}
