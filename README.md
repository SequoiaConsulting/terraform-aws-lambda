# terraform-aws-lambda
Terraform module for provisioning a Lambda function.

This module gives option to create an empty (place-holder) Lambda function using the "create_empty_function" argument, rather than using Terraform to deploy the actual function code. Once all infrastructure, functions, and permissions have been provisioned using Terraform, you can use your CI/CD tooling to deploy the function code, typically with an **aws lambda update** command. This solves the chicken

# Inputs
Many of the module arguments map directly to the aws_lambda_function resource arguments:
* function_name
* filename
* description
* runtime
* handler
* timeout
* memory_size
* environment_variables
* tags
* vpc_config
* reserved_concurrent_executions
* publish

<<<<<<< HEAD
## Additional Inputs:
=======
Additional arguments are:
* **create_empty_function** - (Required) (bool) - Create an empty lambda function without the actual code if set to true
* **policies** - (Required) (string) - The module automatically creates a base IAM role for each lambda, This is a JSON string of statement policies to add to that role.
* **managed_policies** - (Optional) (string) - AWS Managed policies to add to the Lambda IAM role. This is list of strings - each string having ARN of the IAM role.
* **permissions** - (Optional) (list) - A list of external resources which can invoke the lambda function such as s3 bucket / sns topic. Properties are:
  * statement_id
  * action
  * principal
  * source_arn
>>>>>>> 97734c9ab492c8e64c79e908b1ba8f5db5bd7fd7

| Input   | Optional?    | Type | Description |
| ------- | ------------ | -----|------------ |    
| create\_empty\_function |  No |  bool |  Create an empty place-holder Lambda function without the actual code if set to true |
| policies | No | string | The module automatically creates a base IAM role for each Lambda, This is JSON encoded policy string for adding to that role. |
| managed\_policies | Yes | list(string) | A list of AWS Managed polices to attach to the Lambda role |
| permissions | Yes | map | External resources which can invoke the Lambda function such as S3 bucket / SNS topic. Properties in map are:  statement_id, action, principal, source_arn.

## Event trigger arguments

### SNS topic trigger
* **sns_topic_subscription** (Optional) (map) - The SNS topic ARN which trigger the Lambda function`

### Cron schedule
* **trigger_schedule** (Optional) (map) - Configures the Lambda function to trigger on a schedule. Properties
    * enabled (bool) - true | false
    * schedule_expression (string) - AWS schedule expressions rule: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html . Examples
        * rate(5 minutes)
        * rate(1 hour)
        * rate(1 day)

### S3 bucket trigger

In addition to the trigger, make sure you
 * Add sufficient permissions to the Lambda role to interact with s3 (E.g s3:GetObject)
 * Add the source resource has permissions to invoke the Lambda (see **permissions** argument)

* **bucket_trigger** - (Optional) (map) - Configures the Lambda function to trigger on s3 bucket ObjectCreated events. Has two properties:
    * enabled (bool) - true | false
    * bucket (string) - The bucket name only (Not the full bucket arn!)

### SQS trigger

Ensure you add the following permissions to the Lambda role
* sqs:ReceiveMessage
* sqs:DeleteMessage
* sqs:GetQueueAttributes

* **source_mappings** - (Optional) (list) - A list of maps to configured the Lambda function to trigger on SQS events. Maps to resource aws_lambda_event_source_mapping. Has the following properties
  * enabled (bool) - true | false
  * event_source_arn (string) - arn of the event source
  * batch_size (int) - The largest number of records that Lambda will retrieve from your event source at the time of invocation
