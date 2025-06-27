## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "function_name" {
  type        = string
  description = "AWS Lambda Function Sourcec File Name"
}

variable "function_contents" {
  type = list(object({
    filepath = string,
    filename = string
  }))
  description = "Full File Paths to Function's Source Code to Zip into single Artifact"
}

variable "function_handler" {
  type        = string
  description = "AWS Lambda Function Source Handler Function Name"
}

variable "bronze_bucket_id" {
  type        = string
  description = "Target S3 Bucket Name"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Encryption Key ARN"
}

variable "sns_topic_arn" {
  type        = string
  description = <<EOT
    Lambda Function Dead Letter Queue for failed messages.
    Must be either an SNS Topic ARN or SQS Queue
    EOT
}

## ---------------------------------------------------------------------------------------------------------------------
## OPTIONAL PARAMETERS
## These variables have defaults and may be overridden
## ---------------------------------------------------------------------------------------------------------------------

variable "program_name" {
  type        = string
  description = "Program Name"
  default     = "dp-lessons"
}

variable "project_name" {
  type        = string
  description = "Project name for data ingestion"
  default     = "ex-data-ingestion"
}

variable "function_bucket_name" {
  type        = string
  description = "S3 Function Source Bucket Name"
  default     = "blob-trigger-source-code-bucket"
}

variable "function_trigger_events" {
  type        = list(string)
  description = "AWS S3 Trigger Events"
  default     = ["s3:ObjectCreated:*"]
}

variable "function_runtime" {
  type        = string
  description = "AWS Lambda Function Runtime Environment"
  default     = "python3.9"
}

variable "function_memory" {
  type        = number
  description = "AWS Lambda Function Allocated Memory in MBs"
  default     = 256
}

variable "function_dependencies" {
  type = list(object({
    package_name    = string
    package_version = string
    no_dependencies = bool
  }))
  description = "AWS Lambda Function Source Code Dependencies"
  default     = []
}

variable "function_timeout" {
  type        = number
  description = "AWS Lamdba Function timeout in seconds"
  default     = 3
}

variable "function_environment_variables" {
  type        = map(any)
  description = "Mapping AWS Lamdba Function Env Variables"
  default     = {}
}

variable "function_concurrency" {
  type        = number
  description = "Lambda Function Execution Concurrency Limit"
  default     = 5
}

variable "cloudwatch_logs_retention_days" {
  type        = number
  description = "AWS Cloudwatch logs retention period for Lambda Function"
  default     = 1
}