resource "aws_autoscaling_group" "TerraformPhonebook-ASG" {
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  name                      = "TerraformPhonebook-ASG"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_alb_target_group.TerraformPhonebook-Alb-Tg.arn]
  vpc_zone_identifier       = aws_alb.TerraformPhonebook-Alb.subnets
  launch_template {
    id      = aws_launch_template.TerraformPhonebook-Lt.id
    version = aws_launch_template.TerraformPhonebook-Lt.latest_version
  }
}