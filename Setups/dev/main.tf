provider "aws" {
    region = "us-east-1"
   
}


# call the module, state the source, and pass the in the value for the variables
module "vpc" {
   source = "../../Modules/vpc"
   vpc_cidr   = "10.0.0.0/16"
   public_ciders = ["10.0.1.0/24", "10.0.2.0/24"]
   private_ciders = ["10.0.3.0/24", "10.0.4.0/24"]
  
}

module "ec2" {
  source         = "../../Modules/ec2"
  my_public_key  = "/tmp/id_rsa.pub"
  instance_type  = "t2.micro"
  security_group = module.vpc.security_group
  subnets        = module.vpc.public_subnets
}


module "alb" {
  source = "../../Modules/alb"
  vpc_id = module.vpc.vpc_id
  instance1_id = module.ec2.instance1_id
  instance2_id = module.ec2.instance2_id
  subnet1 = module.vpc.subnet1
  subnet2 = module.vpc.subnet2
}

module "auto_scaling" {
  source           = "../../Modules/auto_scaling"
  vpc_id           = module.vpc.vpc_id
  subnet1          = module.vpc.subnet1
  subnet2          = module.vpc.subnet2
  target_group_arn = module.alb.alb_target_group_arn
}


module "route53" {
  source   = "../../Modules/route53"
  hostname = ["host1", "host2"]
  arecord  = ["10.0.1.11", "10.0.1.12"]
  vpc_id   = module.vpc.vpc_id
}

module "iam" {
  source   = "../../Modules/iam"
  username = ["user1", "user2", "user3"]
}

module "s3" {
  source         = "../../Modules/s3"
  s3_bucket_name = "dev-s3-bucket"
}

module "cloudtrail" {
  source          = "../../Modules/cloudtrail"
  cloudtrail_name = "dev-cloudtrail"
  s3_bucket_name  = "cloudtrail-s3-bucket"
}

module "transit_gateway" {
  source         = "../../Modules/transit_gateway"
  vpc_id         = module.vpc.vpc_id
  public_subnet1 = module.vpc.subnet1
  public_subnet2 = module.vpc.subnet2
}

module "kms" {
  source   = "./kms"
  user_arn = module.iam.aws_iam_user
}
