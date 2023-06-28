resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
}

# make the objects public for the website
resource "aws_s3_bucket_public_access_block" "s3_bucket_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = false 
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# add bucket ownership control to bucket owner
resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_ctrl" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  rule {
      object_ownership    = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.s3_bucket_access_block]
}

# making the s3 bucket public 
# allow acls
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  depends_on  = [ aws_s3_bucket_ownership_controls.s3_bucket_ownership_ctrl,
                  aws_s3_bucket_public_access_block.s3_bucket_access_block,
                  ]
  bucket      = aws_s3_bucket.s3_bucket.id
  acl         = "public-read"   
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  depends_on  = [aws_s3_bucket_public_access_block.s3_bucket_access_block]
  bucket      = aws_s3_bucket.s3_bucket.id
  policy      = jsonencode(
    {
      "Version": "2008-10-17",
      "Id": "ContentsAllow",
      "Statement": [
        {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": [
            "arn:aws:s3:::${var.s3_bucket_name}/*",
            "arn:aws:s3:::${var.s3_bucket_name}",
            ]
        }
      ]
    }
  )
}

# load mime types
locals {
  mime_types = jsondecode(file("mime.json"))
}

# send website files to s3 bucket
# ref: https://engineering.statefarm.com/blog/terraform-s3-upload-with-mime/
resource "aws_s3_object" "provisiton_app_files_to_s3" {
  bucket        = aws_s3_bucket.s3_bucket.id
  for_each      = fileset("../app/", "**/*.*")
  key           = each.value
  source        = "../app/${each.value}"
  etag          = filemd5("../app/${each.value}")
  content_type  = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket                = aws_s3_bucket.s3_bucket.id
  cors_rule {
    allowed_headers     = ["*"]
    allowed_methods     = ["GET", "POST"]
    allowed_origins     = ["*"]
    expose_headers      = []
    max_age_seconds     = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket                = aws_s3_bucket.s3_bucket.bucket
  index_document {
    suffix              = "index.html"
  }
}