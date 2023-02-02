provider "aws" {
  region = "us-east-1"
  alias  = "aws-east-environment"
}

resource "aws_acm_certificate" "cloudfront" {
    count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod

    domain_name       = "*.domain.com"
    validation_method = "DNS"
    provider          = aws.aws-east-environment

    tags = {
        Environment = "${var.bucket_name_prod}-${var.environment_name}-cert"
    }
}

resource "aws_acm_certificate_validation" "cloudfront" {
    count = terraform.workspace == "route53-domain-prod" ? 1 : 0

    certificate_arn         = element(aws_acm_certificate.cloudfront.*.arn, count.index)
    validation_record_fqdns = [for record in aws_route53_record.root_domain : record.fqdn]
    provider                = aws.aws-east-environment
}
