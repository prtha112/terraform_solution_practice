data "aws_security_group" "xxx_sg_group" {
   tags = {
        Name = var.db_security_group_name 
   } 
}