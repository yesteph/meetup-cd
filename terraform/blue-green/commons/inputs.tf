variable "aws_region" {}
variable "vpc_cidr" {}

variable "deployment_step" {
  type        = "string"
  description = "The deployment_step to launch"
}