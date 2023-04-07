## create target group
resource "aws_lb_target_group" "tg" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sri.id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
## create target group attachement
resource "aws_lb_target_group_attachment" "tg-attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance[count.index].id
  port             = 80
}
## create load balancer
resource "aws_lb" "lb1" {
  name               = "lb1-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [for subnet in aws_subnet.sss : subnet.id]

  enable_deletion_protection = true
  tags = {
    Environment = "production"
  }
}