terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "random_id" "name" {
  byte_length = 6
  prefix      = "terraform-aws-lambda-test-0_12_X"
}

module "lambda_with_env_vars" {
  source = "../../"

  function_name = "${random_id.name.hex}-with-env-vars"
  description   = "Test terraform-aws-lambda with Terraform 0.12.x with env vars"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.6"
  timeout       = 30

  environment = {
    variables = {
      foo = "1"
      bar = "zombo"
      baz = 123
    }
  }

  source_path = "${path.module}/lambda.py"
}

module "lambda_without_env_vars" {
  source = "../../"

  function_name = "${random_id.name.hex}-without-env-vars"
  description   = "Test terraform-aws-lambda with Terraform 0.12.x without env vars"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.6"
  timeout       = 30

  source_path = "${path.module}/lambda.py"
}
