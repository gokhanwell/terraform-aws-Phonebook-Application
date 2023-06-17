resource "aws_alb_target_group" "TerraformPhonebook-Alb-Tg" {
  name        = "TerraformPhonebook-Alb-Tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Terraform-VPC.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_alb" "TerraformPhonebook-Alb" {
  name               = "TerraformPhonebook-Alb"
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.TerraformALBSecurityGroup.id]
  subnets            = [aws_subnet.Terraform-Public-Subnet-1.id, aws_subnet.Terraform-Public-Subnet-2.id, aws_subnet.Terraform-Public-Subnet-3.id]
  tags = {
    Name = "TerraformPhonebook-Alb"
  }
}

resource "aws_alb_listener" "TerraformPhonebook-Alb-Listener" {
  load_balancer_arn = aws_alb.TerraformPhonebook-Alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.TerraformPhonebook-Alb-Tg.arn
  }
}
