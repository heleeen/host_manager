terraform {
  backend "s3" {
    region = "ap-northeast-1"
    key    = "host_manager.tfstate"
  }
}

provider "aws" {
  region = var.region
}

module "function" {
  source = "git@github.com:heleeen/heleeen_terraform.git//lambda?ref=v0.2"
  name   = var.name
  environments = map(
    "CLUSTER_NAME", var.cluster_name
  )
}

# IAM
resource "aws_iam_role_policy_attachment" "ecs" {
  role       = module.function.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = module.function.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
