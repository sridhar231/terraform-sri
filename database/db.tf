resource "aws_security_group" "db" {
  name        = "mysql"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sri.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.sri_vpc_info.vpc_cidr]
  }

  tags = {
    Name = "mysql"
  }
  depends_on = [
    aws_subnet.sss

  ]
}
data "aws_subnets" "db" {
  filter {
    name   = "tag:Name"
    values = var.sri_vpc_info.db_subnets
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.sri.id]
  }
  depends_on = [
    aws_subnet.sss
  ]

}
resource "aws_db_subnet_group" "sri" {
  name       = "sri"
  subnet_ids = data.aws_subnets.db.ids

  depends_on = [
    aws_subnet.sss
  ]
}
resource "aws_db_instance" "empdb" {
  allocated_storage      = 20
  db_name                = "qtemployess"
  engine                 = "mysql"
  db_subnet_group_name   = "sri"
  engine_version         = "8.0.28"
  instance_class         = "db.t2.micro"
  username               = "rootroot"
  password               = "adminroot"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true

  depends_on = [
    aws_db_subnet_group.sri,
    aws_security_group.db
  ]
}
