data "aws_iam_role" "role_rds_monitor" {
    name = "rds-monitoring-role"
}

resource "aws_iam_role" "role_rds_proxy_xxx" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "rds.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [
        aws_iam_policy.policy_rds_proxy_xxx.arn,
    ]
    max_session_duration  = 3600
    name                  = var.rds_proxy_role_name
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}

    depends_on = [
      aws_iam_policy.policy_rds_proxy_xxx
    ]
}
