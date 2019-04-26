variable "secret_name_prefix" {
  description = "should be something like vault_instanceid, cannot be duplicates name in the secrets and when you delete the name is retained at least for 7 days"
}

variable "instanceid" {
  description = "the instance id like i-00112233445566"
}

variable "rotation_days" {
  default = 30
  description = "how often the password needs to be rotated"
}

variable "rotation_lambda_arn" {
  description = "the arn of the lambda that perform the rotation, is created with the other module"
}
