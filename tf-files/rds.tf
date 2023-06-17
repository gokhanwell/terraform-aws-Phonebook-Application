resource "aws_db_subnet_group" "Terraform-RDS-Subnet-Group" {
  name       = "terraform-rds-subnet-group"
  subnet_ids = [aws_subnet.Terraform-Public-Subnet-1.id, aws_subnet.Terraform-Public-Subnet-2.id, aws_subnet.Terraform-Public-Subnet-3.id]
  tags = {
    Name = "Terraform-RDS-Subnet-Group"
  }
}

resource "aws_db_instance" "TerraformMysqldb" {
  instance_class              = var.rds_instance_type
  allocated_storage           = 20
  vpc_security_group_ids      = [aws_security_group.TerraformRDSSecurityGroup.id]
  db_subnet_group_name        = aws_db_subnet_group.Terraform-RDS-Subnet-Group.name
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 0
  identifier                  = "terraform-mysqldb-phonebook"
  name                        = "gokhanwell_phonebook"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  username                    = "admin"
  password                    = "gokhanwell"
  monitoring_interval         = 0
  multi_az                    = false
  port                        = 3306
  publicly_accessible         = false
  skip_final_snapshot         = true

}