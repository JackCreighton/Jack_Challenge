
resource "aws_cloudfront_origin_access_identity" "oai_policy" {
  comment = "s3_website"
}

data "aws_iam_policy_document" "read_website_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai_policy.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai_policy.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "website_bucket" {
    bucket = "${var.bucket_name}"
    acl = "public-read"

    website {
        index_document = "index.html"
    }
    
}

resource "aws_s3_bucket_policy" "read_website_policy" {
    bucket = aws_s3_bucket.website_bucket.id
    policy = data.aws_iam_policy_document.read_website_bucket.json
}

resource "aws_s3_bucket_object" "static_page_object" {
    bucket = aws_s3_bucket.website_bucket.bucket
    key = "index.html"
    content_type = "text/html"
    content_disposition = "inline; filename=index.html"
    source = "${var.index_document_path}"
    acl = "public-read"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    enabled = true
    default_root_object = "index.html"

    origin {
      domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
      origin_id = aws_s3_bucket.website_bucket.bucket

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.oai_policy.cloudfront_access_identity_path
      }
    }

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD"]
        cached_methods  = ["GET", "HEAD"]

        target_origin_id = aws_s3_bucket.website_bucket.bucket

        viewer_protocol_policy = "redirect-to-https"

        min_ttl     = 0
        default_ttl = 5 * 60
        max_ttl     = 60 * 60

        forwarded_values {
            query_string = true

            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}