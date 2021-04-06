resource "aws_db_instance" "wordpress_database" {

  allocated_storage = 5
  storage_type      = "gp2"
  engine_version    = "5.7"
  skip_final_snapshot = true
  engine            = "mysql"
  name              = var.database_name
  password          = var.database_password
  username          = var.database_username
  instance_class    = var.rds_instance_type
  identifier = "${var.project_name}-${var.environment_name}"
  vpc_security_group_ids = [ aws_security_group.database_security_group.id ]

}

output "wordpress_database_endpoint" {
  value = aws_db_instance.wordpress_database.endpoint
}
