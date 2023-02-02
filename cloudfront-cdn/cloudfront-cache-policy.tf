resource "aws_cloudfront_cache_policy" "domain_cache_policy_nonprod" {
  name        = "${var.bucket_name_nonprod}-policy"
  comment     = "${var.bucket_name_nonprod} policy"
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}

resource "aws_cloudfront_cache_policy" "domain_cache_policy_prod" {
  name        = "${var.bucket_name_prod}-policy"
  comment     = "${var.bucket_name_prod} policy"
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}