output "domain" {
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "bucket_id" {
    value = aws_s3_bucket.website_bucket.id
}