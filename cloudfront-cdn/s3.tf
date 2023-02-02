resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "domain-file.s3.ap-southeast-1.amazonaws.com"
}

resource "aws_s3_bucket_public_access_block" "api_public_access_block" {
  bucket = aws_s3_bucket.bucket_static_file.id

  block_public_acls       = true
  block_public_policy     = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_static_file.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
  statement {
    actions   = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.bucket_static_file.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::xxxxxxxxxxxxxx:user/jenkins-prod"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket_static_file.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "bucket_static_file" {
  bucket = lower(var.bucket_name_prod)

  tags = {
    Name        = lower(var.bucket_name_prod)
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket_static_file.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encrypt" {
  bucket = aws_s3_bucket.bucket_static_file.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

##### Nonprod #######
resource "aws_cloudfront_origin_access_identity" "origin_access_identity_nonprod" {
  comment = "domain-file-nonprod.s3.ap-southeast-1.amazonaws.com"
}

resource "aws_s3_bucket_public_access_block" "api_public_access_block_nonprod" {
  bucket = aws_s3_bucket.bucket_static_file_nonprod.id

  block_public_acls       = true
  block_public_policy     = true
}

data "aws_iam_policy_document" "s3_policy_nonprod" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_static_file_nonprod.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity_nonprod.iam_arn]
    }
  }
  statement {
    actions   = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.bucket_static_file_nonprod.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::xxxxxxxxxxxx:user/jenkins-nonprod"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy_nonprod" {
  bucket = aws_s3_bucket.bucket_static_file_nonprod.id
  policy = data.aws_iam_policy_document.s3_policy_nonprod.json
}

resource "aws_s3_bucket" "bucket_static_file_nonprod" {
  bucket = lower(var.bucket_name_nonprod)

  tags = {
    Name        = lower(var.bucket_name_nonprod)
  }
}

resource "aws_s3_bucket_acl" "bucket_acl_nonprod" {
  bucket = aws_s3_bucket.bucket_static_file_nonprod.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encrypt_nonprod" {
  bucket = aws_s3_bucket.bucket_static_file_nonprod.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}