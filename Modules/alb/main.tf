provider "aws" {
  region = "us-east-1"
}


resource "aws_lb_target_group" "target-group" {

 health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }


  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


# Attach EC2 instances to alb target group

resource "aws_lb_target_group_attachment" "alb-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = var.instance1_id
  port             = 80
}


resource "aws_lb_target_group_attachment" "alb-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = var.instance2_id
  port             = 80
}


# Create the applicaition load balancer - internet facing

resource "aws_lb" "aws-alb" {
  name     = "dev-alb"
  internal = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"

  security_groups = [aws_security_group.aws-alb-sg.id]

  subnets = [
    var.subnet1,
    var.subnet2,
  ]

  tags = {
    Envrironment = "dev"
  }

  
}

# create lb listener and define listener port

resource "aws_lb_listener" "alb-listner" {
  load_balancer_arn = aws_lb.aws-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

