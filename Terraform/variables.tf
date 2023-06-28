variable "aws_region" {
  default     = "ap-south-1"
  description = "your aws region"
}

variable "s3_bucket_name" {
  default     = "static-website-s3-bucket"
  description = "name of s3 bucket. store website files in this bucket."
}

