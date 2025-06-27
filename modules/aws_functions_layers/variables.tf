## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "bucket_id" {
  type        = string
  description = "AWS Storage Bucket ID for Lambda Source Code"
}

variable "package_name" {
  type        = string
  description = "Python Dependency Package Required for Lambda Function"
}

variable "package_version" {
  type        = string
  description = "Python Dependency Package Version"
}

## ---------------------------------------------------------------------------------------------------------------------
## OPTIONAL PARAMETERS
## These variables have defaults and may be overridden
## ---------------------------------------------------------------------------------------------------------------------

variable "no_dependencies" {
  type        = bool
  description = "Flag for pip to Install Dependencies"
  default     = true
}

variable "function_runtime" {
  type        = string
  description = "AWS Lambda Function Runtime Environment"
  default     = "python3.9"
}