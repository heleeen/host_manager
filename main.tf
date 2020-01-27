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
  source = "git@github.com:heleeen/heleeen_terraform.git//lambda_iam?ref=v0.1"
  name   = var.name
}

module "function" {
  source   = "git@github.com:heleeen/heleeen_terraform.git//lambda_function?ref=v0.1"
  name     = var.name
  role_arn = module.iam.role_arn
  environments = map(
    "CLUSTER_NAME", var.cluster_name
  )
}

# IAM
resource "aws_iam_role_policy_attachment" "ecs" {
  role       = module.iam.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = module.iam.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
