resource "aws_security_group" "security" {
  name        = "sg"
   vpc_id      = aws_vpc.sri.id

  ingress {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.sri.cidr_block]
    
  }