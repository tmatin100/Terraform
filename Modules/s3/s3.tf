resource "aws_s3_bucket" "dev_bucket" {
  bucket = "dev_bucket"
  acl    = "private"

  tags = {
    Name        = "s3-dev-bucket"
    Environment = "Dev"
  }
}

output "s3BucketOUtput" {
    value = aws_s3_bucket.dev_bucket.id
}