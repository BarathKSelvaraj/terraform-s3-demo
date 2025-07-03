output "website_url" {
  description = "Static Website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}
