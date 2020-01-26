resource "aws_lambda_function" "monitor" {
  function_name    = var.name
  handler          = format("%s.%s", var.name, "exec")
  role             = var.role_arn
  runtime          = "ruby2.5"
  filename         = data.archive_file.function.output_path
  source_code_hash = data.archive_file.function.output_base64sha256

  environment {
    variables = {
      CLUSTER_NAME = var.cluster_name
    }
  }
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "function"
  output_path = "script.zip"
}

# TODO log group
