resource "aws_cloudfront_function" "custom-header-domain-nonprod" {
  name    = "domain-custom-header-nonprod"
  runtime = "cloudfront-js-1.0"
  comment = "Function nonprod.domain.com for custom header"
  publish = true
  code    = file("${path.module}/custom_response_header.js")
}

resource "aws_cloudfront_function" "custom-header-domain-prod" {
  name    = "domain-custom-header-prod"
  runtime = "cloudfront-js-1.0"
  comment = "Function x.domain.com for custom header"
  publish = true
  code    = file("${path.module}/custom_response_header.js")
}