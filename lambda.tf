# Creates the Lambda Function
resource "aws_lambda_function" "lambda_function" {
  filename      = var.path_to_zip                           # Path to the Lambda deployment package
  function_name = var.function_name                         # Name of the package 
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = var.application_language                  # Version of Python
  source_code_hash = filebase64sha256(var.path_to_zip)      # Path to the Lambda deployment

  # Environment variables in key = value format
  environment {
    variables = {
      for key, value in var.environment_variables :
      key => value
    }
  }
  
  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids         = data.aws_subnets.private.ids
  }

  layers = [aws_lambda_layer_version.lambda_layer.arn]
}

# Creates the CloudWatch resources for scheduling of the Lambda Function and Logs
resource "aws_cloudwatch_event_target" "schedule_rule" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda_function_target"
  arn       = aws_lambda_function.lambda_function.arn 
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name        = var.cloudwatch_name
  description = var.placeholder
  schedule_expression = var.event_schedule_cron
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.log_retention
  lifecycle {
    prevent_destroy = false
  }
}

# Creates the IAM Policy and Role for the Relevant Permissions
resource "aws_iam_policy" "access_policy" {
  name          = var.policy_name
  description   = var.placeholder
  path          = var.iam_path
  policy        = var.access_policy
}

resource "aws_iam_role" "lambda_role" {
  name = var.role_name
  path                 = var.iam_path
  managed_policy_arns  = [aws_iam_policy.access_policy.arn]
  permissions_boundary  = var.permissions_boundary

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = "requests"

  filename  = var.path_to_layer

  compatible_runtimes = ["python3.9"]
}