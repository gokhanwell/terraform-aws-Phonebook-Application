data "aws_vpc" "selected-vpc" {
  default = true
}

data "aws_subnets" "selected-subnet" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected-vpc]
  }
}

data "aws_ami" "amazon-linux-2" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_template" "TerraformPhonebook-Lt" {
  name = "TerraformPhonebook-Lt"
  image_id = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name = "firstkey"
  vpc_security_group_ids = [aws_security_group.TerraformWebServerSecurityGroup.id]
  user_data = filebase64("user-data.sh")
  depends_on = [github_repository_file.dbendpoint]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "TerraformPhonebook-Lt"
    }
  }
}

resource "aws_alb_target_group" "TerraformPhonebook-Alb-Tg" {
  name = "TerraformPhonebook-Alb-Tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.selected-vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    tags = {
      Name = "TerraformPhonebook-Alb-Tg"
    }
  }
}

resource "aws_alb" "TerraformPhonebook-Alb" {
  name = "TerraformPhonebook-Alb"
  ip_address_type = "ipv4"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.TerraformALBSecurityGroup.id]
  subnets = data.aws_subnets.selected-subnet.ids
    tags = {
      Name = "TerraformPhonebook-Alb"
    }
}

resource "aws_alb_listener" "TerraformPhonebook-Alb-Listener" {
  load_balancer_arn = aws_alb.TerraformPhonebook-Alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.TerraformPhonebook-Alb-Tg.arn
  }
}

resource "aws_autoscaling_group" "TerraformPhonebook-ASG" {
  max_size = 3
  min_size = 1
  desired_capacity = 2
  name = "TerraformPhonebook-ASG"
  health_check_grace_period = 300
  health_check_type = "ELB"
  target_group_arns = [aws_alb_target_group.TerraformPhonebook-Alb-Tg.arn]
  vpc_zone_identifier = aws_alb.TerraformPhonebook-Alb.subnets
  launch_template {
    id = aws_launch_template.TerraformPhonebook-Lt.id
    version = aws_launch_template.TerraformPhonebook-Lt.latest_version
  }
}

resource "aws_db_instance" "TerraformMysqldb" {
  instance_class = "db.t2.micro"
  allocated_storage = 20
  vpc_security_group_ids = [aws_security_group.TerraformRDSSecurityGroup.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = true
  backup_retention_period = 0
  identifier = "TerraformMysqldbPhonebook"
  name = "gokhanwell_phonebook"
  engine = "mysql"
  engine_version = "8.0.28"
  username = "admin"
  password = "gokhanwell"
  monitoring_interval = 0
  multi_az = false
  port = 3306
  publicly_accessible = false
  skip_final_snapshot = false #true

}

resource "github_repository_file" "TerraformDbEndpoint" {
  content = aws_db_instance.TerraformMysqldb.address
  file = "dbserver.endpoint"
  repository = "terraform-aws-Phonebook-Application"
  overwrite_on_create = true
  branch = "main"
}