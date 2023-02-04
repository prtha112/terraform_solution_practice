resource "aws_iam_policy" "policy_rds_proxy_xxx" {
    description = "Allows RDS Proxy access to database connection credentials"
    name        =  var.rds_proxy_policy_name
    path        = "/service-role/"
    policy      = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "secretsmanager:GetSecretValue",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        var.rds_secret_arn,
                    ]
                    Sid      = "GetSecretValue"
                },
                {
                    Action    = [
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "secretsmanager.ap-southeast-1.amazonaws.com"
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        var.policy_kms_id,
                    ]
                    Sid       = "DecryptSecretValue"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags        = {}
    tags_all    = {}
}
