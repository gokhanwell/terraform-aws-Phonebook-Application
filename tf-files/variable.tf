variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr_block" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr_block" {
  default = "10.0.2.0/24"
}

variable "public_subnet_3_cidr_block" {
  default = "10.0.3.0/24"
}

variable "github_token" {
  default = "XXXXXXXXXXXXXX"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "key-name" {
  default = "XXXXXXXXXX"
}

variable "rds_instance_type" {
  default = "db.t2.micro"
}