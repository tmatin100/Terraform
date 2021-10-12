provider "aws" {
    region = "us-east-1"
   
}


terraform {

    required_version = ">=0.12"

    backend "s3" {
    bucket = "devops-tf-states"  #creating a sepererate bucket for backend
    key = "terraform.tfstate"   #we can use a seperate key for backend
    region = "us-east-1"
    encrypt = true

  tags = {
      Name = "terraform-backend"
      Envirionment = "dev"
}

output "s3BucketOutput"
    value = aws_s3_bucket.devops-tf-states.id