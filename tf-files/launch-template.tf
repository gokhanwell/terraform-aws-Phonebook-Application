data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_template" "TerraformPhonebook-Lt" {
  name                   = "TerraformPhonebook-Lt"
  image_id               = data.aws_ami.amazon-linux-2.id
  instance_type          = var.ec2_type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.TerraformWebServerSecurityGroup.id]
  user_data              = filebase64("${path.module}/user-data.sh")
  depends_on             = [github_repository_file.TerraformDbEndpoint]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "TerraformPhonebook-Lt"
    }
  }
}
