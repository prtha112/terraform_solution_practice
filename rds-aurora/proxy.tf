# aws_db_proxy.xxx_aurora_proxy:
resource "aws_db_proxy" "xxx_aurora_proxy" {
    debug_logging          = false
    engine_family          = "MYSQL"
    idle_client_timeout    = 5400
    name                   = var.rds_proxy_name
    require_tls            = false
    role_arn               = aws_iam_role.role_rds_proxy_xxx.arn 
    tags                   = {}
    tags_all               = {}
    
    vpc_security_group_ids = [
        var.vpc_security_group_ids,
    ]
    vpc_subnet_ids         = [
        var.vpc_subnet_ids_1,
        var.vpc_subnet_ids_2,
    ]

    auth {
        auth_scheme = "SECRETS"
        iam_auth    = "DISABLED"
        secret_arn  = var.rds_secret_arn
    }

    timeouts {}

    depends_on = [
      aws_iam_role.role_rds_proxy_xxx,
      aws_rds_cluster_instance.rds_db
    ]
}

# aws_db_proxy_default_target_group.xxx_aurora_proxy_target_group:
resource "aws_db_proxy_default_target_group" "xxx_aurora_proxy_target_group" {
    db_proxy_name = aws_db_proxy.xxx_aurora_proxy.name

    connection_pool_config {
        connection_borrow_timeout    = 120
        max_connections_percent      = 100
        max_idle_connections_percent = 50
        session_pinning_filters      = []
    }

    timeouts {}

    depends_on = [
      aws_db_proxy.xxx_aurora_proxy
    ]
}

# aws_db_proxy_target.xxx_aurora_proxy_target:
resource "aws_db_proxy_target" "xxx_aurora_proxy_target" {
    db_cluster_identifier = aws_rds_cluster.rds_db_cluster.id
    db_proxy_name         = aws_db_proxy.xxx_aurora_proxy.name
    target_group_name     = aws_db_proxy_default_target_group.xxx_aurora_proxy_target_group.name 

    depends_on = [
      aws_rds_cluster.rds_db_cluster,
      aws_db_proxy.xxx_aurora_proxy,
      aws_db_proxy_default_target_group.xxx_aurora_proxy_target_group
    ]
}

# aws_db_proxy_endpoint.xxx_aurora_proxy_endpoint:
resource "aws_db_proxy_endpoint" "xxx_aurora_proxy_endpoint" {
    db_proxy_endpoint_name = var.rds_proxy_endpoint_name 
    db_proxy_name          = aws_db_proxy.xxx_aurora_proxy.name
    tags                   = {}
    tags_all               = {}
    target_role            = "READ_ONLY"
    vpc_security_group_ids = [
        var.vpc_security_group_ids,
    ]
    vpc_subnet_ids         = [
        var.vpc_subnet_ids_1,
        var.vpc_subnet_ids_2,
    ]

    timeouts {}

    depends_on = [
      aws_db_proxy.xxx_aurora_proxy
    ]
}
