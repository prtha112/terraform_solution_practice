resource "aws_lambda_function" "xxx-cert-monitor" {
  function_name = "xxx-cert-monitor"
  description   = "xxx-cert-monitor"
  architectures = ["arm64"]
  memory_size   = 128 
  timeout       = 60

  timeouts {
    create = "30m"
  }

  runtime          = "python3.9"
  role             = aws_iam_role.xxx-cert-monitor-role.arn
  filename         = data.archive_file.source.output_path
  source_code_hash = data.archive_file.source.output_base64sha256
  handler          = "lambda_function.lambda_handler"

  environment {
    variables = {
      lambda_name = "xxx-cert-monitor",
      lambda_type = "system-monitor",
      lambda_environment = var.enverionment 
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam-policy-attach
  ]
}

resource "aws_iam_role" "xxx-cert-monitor-role" {
  name = "xxx_cert_monitor_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
            Service = "lambda.amazonaws.com"
        }
        Effect   = "Allow"
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_policy" "xxx-cert-monitor-policy" {
  name = "xxx-cert-monitor-policy"
  description = "IAM Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "acm:GetCertificate"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam-policy-attach" {
  role       = "${aws_iam_role.xxx-cert-monitor-role.name}"
  policy_arn = "${aws_iam_policy.xxx-cert-monitor-policy.arn}"
}