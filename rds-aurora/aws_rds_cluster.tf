resource "aws_rds_cluster_instance" "rds_db" {
  count = 1
  auto_minor_version_upgrade            = true
  availability_zone                     = "ap-southeast-1b"
  ca_cert_identifier                    = "rds-ca-2019"
  cluster_identifier                    = aws_rds_cluster.rds_db_cluster.id
  copy_tags_to_snapshot                 = false
  db_parameter_group_name               = var.db_parameter_group_name
  db_subnet_group_name                  = var.db_subnet_group_name
  engine                                = aws_rds_cluster.rds_db_cluster.engine
  engine_version                        = aws_rds_cluster.rds_db_cluster.engine_version
  identifier                            = terraform.workspace == "rds-aurora-xxx-nonprod" ? "${var.rds_identifier}-instance-1" : "${var.rds_identifier}-${count.index}"
  instance_class                        = var.rds_instance_class
  monitoring_interval                   = 60
  monitoring_role_arn                   = data.aws_iam_role.role_rds_monitor.arn
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  promotion_tier                        = 1
  publicly_accessible                   = false
  tags                                  = {}
  tags_all                              = {}

  timeouts {}

  depends_on = [
    aws_rds_cluster.rds_db_cluster
  ]
}

resource "aws_rds_cluster" "rds_db_cluster" {
  availability_zones = [
    "ap-southeast-1a",
    "ap-southeast-1b",
    "ap-southeast-1c"
  ]
  backtrack_window        = 0
  backup_retention_period = 1
  cluster_identifier      = var.rds_identifier
  copy_tags_to_snapshot               = true
  db_cluster_parameter_group_name     = var.db_parameter_group_name
  db_subnet_group_name                = var.db_subnet_group_name
  deletion_protection                 = false
  enable_http_endpoint                = false
  enabled_cloudwatch_logs_exports     = []
  engine                              = var.rds_engine
  engine_mode                         = var.rds_engine_mode
  engine_version                      = var.rds_engine_version
  iam_database_authentication_enabled = false
  iam_roles                           = []
  kms_key_id                          = var.rds_kms_id
  master_username                     = var.rds_username
  master_password                     = var.rds_password
  network_type                        = "IPV4"
  port                                = 3306
  preferred_backup_window             = "17:47-18:17"
  preferred_maintenance_window        = "tue:18:20-tue:18:50"
  skip_final_snapshot                 = true
  storage_encrypted                   = true
  tags                                = {}
  tags_all                            = {}
  vpc_security_group_ids = [
    data.aws_security_group.xxx_sg_group.id
  ]

  serverlessv2_scaling_configuration {
    max_capacity = 32
    min_capacity = 0.5
  }

  timeouts {}
}
