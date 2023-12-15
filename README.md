# Documentation

## Quick Summary

This module is the template for spinning up lambda function resources. This documentation outlines the following: 

 - Procedural: How to spin up your own lambda function
 - What you will need to change: What you will need to change to spin up your own lambda function (in conjunction with Procedural)
 - Technical: What resources the module spins up (and matches the resource to its section of code)
 - @ToDo: Additional tasks to make the module more versatile but can be completed at a later date

## Procedural

This module work in conjunction with the `batcave-landing-zone` repository.

1. From cloudtamer, get the {project}-{environment}'s aws short-term credentials. It will export the following environmental variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `export AWS_SESSION_TOKEN`
2. Run `aws eks update-kubeconfig --name {project}-{environment} --region us-east-1`
3. Go to the `project-environment lambda` directory using `cd <path to blz>/batcave-landing-zone/infra/{project}/{environment}/lambda` 
4. Duplicate the `test` folder and rename it 
5. Make the necessary changes to suit your needs (Refer to the What you will need to Change section)
7. Run `terragrunt plan` to see the resources that will spin up. [1]
8. Once you confirm `terragrunt plan` has no errors, you can run `terragrunt apply`. [2]
9. Logging into the {project}-{environment} AWS account, you can verify the proper resources were created. 

[1] The following resources should spin up Lambda Function, @TODO ADD (Cloudwatch Log Group, Cloudwatch Event Rule, IAM Role, IAM Policy, and any other resources) you decided to add through the `<path to blz>/batcave-landing-zone/infra/batcave/dev/lambda/terragrunt.hcl` `local` section. 

[2] A common error that may show up when running `terragrunt apply` is the resource that you are trying to spin up is already there. Therefore, you will need to delete the resource through the {project}-{environment} AWS account GUI.

## What you will need to Change

 1. Replace the contents of the `python` folder will the new zip file of
    the lambda function's source code.
2. Inside of the `terragrunt.hcl`'s `locals` section, replace the variables.

- `function_name`, `cloudwatch_name`, `role_name`, and `policy_name` are the names of the following AWS resources respectively Lambda Function, Cloudwatch Rule, IAM Role, IAM Policy
- `event_schedule_cron` is the cron expression of how frequent the lambda function will be run. Refer to the following documentation for assistance https://docs.aws.amazon.com/lambda/latest/dg/services-cloudwatchevents-expressions.html
- `log_retention` refers to the number of days the logs will be kept 
- `access_policy` will be the contents of the IAM Policy. This will denote what permissions the lambda function will have in relation to the other aws resources (For example, read/write permissions to an S3 bucket)

## Technical

 `lambda.tf` creates the following

 - Lambda Function based on `resource "aws_lambda_function"
   "lambda_function"`
 - Cloudwatch Target based on
   `resource "aws_cloudwatch_event_rule" aws_cloudwatch_event_rule"` and `resource
   "aws_cloudwatch_event_target" "schedule_rule"`  
  - Cloudwatch Log Group
   based on `aws_cloudwatch_log_group" "function_log_group"`  
   - IAM Policy
   based on `resource "aws_iam_policy" "access_policy"`  
   - IAM Role based
   on `resource "aws_iam_role" "lambda_role" `

## @ToDo

[WIP]
