resource "github_repository_file" "TerraformDbEndpoint" {
  content             = aws_db_instance.TerraformMysqldb.address
  file                = "dbserver.endpoint"
  repository          = "terraform-aws-Phonebook-Application"
  overwrite_on_create = true
  branch              = "main"
}
