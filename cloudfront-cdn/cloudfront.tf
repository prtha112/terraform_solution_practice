resource "aws_cloudfront_distribution" "s3_distribution" {
  count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod
  origin {
    domain_name              = aws_s3_bucket.bucket_static_file.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.bucket_static_file.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 Static file for domain service."
  default_root_object = "index.html"

  aliases = [var.server_name_prod]

  # Cache behavior with precedence 0
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.bucket_static_file.id
    cache_policy_id = aws_cloudfront_cache_policy.domain_cache_policy_prod.id

    function_association {
      event_type = "viewer-response"
      function_arn = aws_cloudfront_function.custom-header-domain-prod.arn
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = [] 
    }
  }

  tags = {
    Environment = "${var.bucket_name_prod}-${var.environment_name}"
  }

  viewer_certificate {
    acm_certificate_arn      = element(aws_acm_certificate.cloudfront.*.arn, count.index)
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  depends_on = [
    aws_acm_certificate.cloudfront
  ]
}

resource "aws_cloudfront_distribution" "s3_distribution_nonprod" {
  count = terraform.workspace == "route53-domain-prod" ? 1 : 0 # Only in prod
  origin {
    domain_name              = aws_s3_bucket.bucket_static_file_nonprod.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.bucket_static_file_nonprod.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity_nonprod.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 Static file for domain service. (Nonprod)"
  default_root_object = "index.html"

  aliases = [var.server_name_nonprod]

  # Cache behavior with precedence 0
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.bucket_static_file_nonprod.id
    cache_policy_id = aws_cloudfront_cache_policy.domain_cache_policy_nonprod.id

    function_association {
      event_type = "viewer-response"
      function_arn = aws_cloudfront_function.custom-header-domain-nonprod.arn
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "${var.bucket_name_nonprod}-nonprod"
  }

  viewer_certificate {
    acm_certificate_arn      = element(aws_acm_certificate.cloudfront.*.arn, count.index)
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  depends_on = [
    aws_acm_certificate.cloudfront
  ]
}