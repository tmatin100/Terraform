# Defineing variables

variable "aws_access_key" {
    type = string
}

variable "aws_secret_key" {
    type = string
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "instancetype" {
    type = string
    default = "t2.micro"
}

variable "envrionment" {
    description = "Name of the envirionment"
    type = string
    default = "dev"
  
}

