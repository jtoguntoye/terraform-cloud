# create RDS DB subnet resource
resource "aws_db_subnet_group" "kiff-rds" {
    name = "main-db"
    subnet_ids = [aws_subnet.private-B[0].id, aws_subnet.private-B[1].id]
  
  tags = merge (
      var.tags,
      {
          Name = "kiff-rds"
      }
  )
}

# create RDS instance with the db subnet groups
resource "aws_db_instance" "kiff-rds" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    name = "kiffdb"
    username = var.master-username
    password = var.master-password
    parameter_group_name = "default.mysql5.7"
    db_subnet_group_name = aws_db_subnet_group.kiff-rds.name
    skip_final_snapshot = true
    vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
    multi_az = true 
}