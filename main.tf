provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.30"
    }
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  tags = {
    Environment = "Development"
    Owner       = "Barath"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
   depends_on = [aws_s3_bucket_public_access_block.my_bucket_block]
}
