data "aws_route53_zone" "domain" {
    count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod

    name                = "domain.com"
}

variable "domain" {
  default = "x.domain.com"
}

resource "aws_route53_record" "root_domain" {
    # count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod 
    for_each = terraform.workspace != "route53-domain-prod" ? {} : {
        for dvo in aws_acm_certificate.cloudfront[0].domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            record = dvo.resource_record_value
            type   = dvo.resource_record_type
        }
    }

    name    = each.value.name
    type    = each.value.type
    zone_id = element(data.aws_route53_zone.domain.*.id, 0)
    records = [each.value.record]
    ttl     = 60
}

resource "aws_route53_record" "s_domain" {
    count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod

    zone_id = element(data.aws_route53_zone.domain.*.id, 0)
    name    = var.server_name_prod
    type    = "A"
    alias {
        name                   = element(aws_cloudfront_distribution.s3_distribution.*.domain_name, count.index)
        zone_id                = element(aws_cloudfront_distribution.s3_distribution.*.hosted_zone_id, count.index)
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "nonprod_domain" {
    count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod

    zone_id = element(data.aws_route53_zone.domain.*.id, 0)
    name    = var.server_name_nonprod
    type    = "A"
    alias {
        name                   = element(aws_cloudfront_distribution.s3_distribution_nonprod.*.domain_name, count.index)
        zone_id                = element(aws_cloudfront_distribution.s3_distribution_nonprod.*.hosted_zone_id, count.index)
        evaluate_target_health = false
    }
}