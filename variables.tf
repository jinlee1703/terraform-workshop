variable "vpc_name" {
  description = "The name of the VPC"
  type = string
  default = "hello"
  nullable = false

  validation {
    condition = length(var.vpc_name) <= 10
    error_message = "The VPC name must be less than 10 characters"
  }
}

variable "tags" {
  description = "A map of tags to add to all resoureces"
  type = map(string)
  default = {}
}