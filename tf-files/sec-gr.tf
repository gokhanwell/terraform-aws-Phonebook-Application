resource "aws_security_group" "TerraformALBSecurityGroup" {
  name = "TerraformALBSecurityGroup"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name = "TerraformALBSecurityGroup"
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "TerraformWebServerSecurityGroup" {
  name = "TerraformWebServerSecurityGroup"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name = "TerraformWebServerSecurityGroup"
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [aws_security_group.TerraformALBSecurityGroup.id]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}



resource "aws_security_group" "TerraformRDSSecurityGroup" {
  name = "TerraformRDSSecurityGroup"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    "Name" = "TerraformRDSSecurityGroup"
  }
  ingress {
    security_groups = [aws_security_group.TerraformWebServerSecurityGroup.id]
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol = -1
    to_port = 0
  }
}