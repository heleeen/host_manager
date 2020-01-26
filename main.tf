terraform {
  backend "s3" {
    region = "ap-northeast-1"
    key    = "host_manager.tfstate"
  }
}

provider "aws" {
  region = var.region
}

module "iam" {
  source = "./terraform/iam"
  name   = var.name
}

module "function" {
  source       = "./terraform/lambda"
  name         = var.name
  role_arn     = module.iam.role_arn
  cluster_name = var.cluster_name
}
