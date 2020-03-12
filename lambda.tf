resource "aws_lambda_function" "lambda" {
  count = ! var.attach_vpc_config && ! var.attach_dead_letter_config ? 1 : 0

  # ----------------------------------------------------------------------------
  # IMPORTANT:
  # Changes made to this resource should also be made to "lambda_with_*" below.
  # ----------------------------------------------------------------------------

  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  layers                         = var.layers
  timeout                        = local.timeout
  publish                        = local.publish
  tags                           = var.tags

  # Use a generated filename to determine when the source code has changed.

  filename   = lookup(data.external.built.result, "filename")
  depends_on = [null_resource.archive]

  # The aws_lambda_function resource has a schema for the environment
  # variable, where the only acceptable values are:
  #   a. Undefined
  #   b. An empty map
  #   c. A map containing 1 element: a key "variables" and a value of
  # a map of environment varable names and values.

  dynamic "environment" {
    for_each = var.environment

    content {
      variables = environment.value
    }
  }
}

# The vpc_config and dead_letter_config variables are lists of maps which,
# due to a bug or missing feature of Terraform, do not work with computed
# values. So here is a copy and paste of of the above resource for every
# combination of these variables.

resource "aws_lambda_function" "lambda_with_dl" {
  count = var.attach_dead_letter_config && ! var.attach_vpc_config ? 1 : 0

  dead_letter_config {
    target_arn = var.dead_letter_config["target_arn"]
  }

  # ----------------------------------------------------------------------------
  # IMPORTANT:
  # Everything below here should match the "lambda" resource.
  # ----------------------------------------------------------------------------

  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  layers                         = var.layers
  timeout                        = local.timeout
  publish                        = local.publish
  tags                           = var.tags
  filename                       = lookup(data.external.built.result, "filename")
  depends_on                     = [null_resource.archive]

  dynamic "environment" {
    for_each = var.environment

    content {
      variables = environment.value
    }
  }
}

resource "aws_lambda_function" "lambda_with_vpc" {
  count = var.attach_vpc_config && ! var.attach_dead_letter_config ? 1 : 0

  vpc_config {
    security_group_ids = [var.vpc_config["security_group_ids"]]
    subnet_ids         = [var.vpc_config["subnet_ids"]]
  }

  # ----------------------------------------------------------------------------
  # IMPORTANT:
  # Everything below here should match the "lambda" resource.
  # ----------------------------------------------------------------------------

  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  layers                         = var.layers
  timeout                        = local.timeout
  publish                        = local.publish
  tags                           = var.tags
  filename                       = lookup(data.external.built.result, "filename")
  depends_on                     = [null_resource.archive]

  dynamic "environment" {
    for_each = var.environment

    content {
      variables = environment.value
    }
  }
}

resource "aws_lambda_function" "lambda_with_dl_and_vpc" {
  count = var.attach_dead_letter_config && var.attach_vpc_config ? 1 : 0

  dead_letter_config {
    target_arn = var.dead_letter_config["target_arn"]
  }

  vpc_config {
    security_group_ids = [var.vpc_config["security_group_ids"]]
    subnet_ids         = [var.vpc_config["subnet_ids"]]
  }

  # ----------------------------------------------------------------------------
  # IMPORTANT:
  # Everything below here should match the "lambda" resource.
  # ----------------------------------------------------------------------------

  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  layers                         = var.layers
  timeout                        = local.timeout
  publish                        = local.publish
  tags                           = var.tags
  filename                       = lookup(data.external.built.result, "filename")
  depends_on                     = [null_resource.archive]

  dynamic "environment" {
    for_each = var.environment

    content {
      variables = environment.value
    }
  }
}
