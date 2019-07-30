variable "aws_profile" {
  description = "The AWS profile."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "ca-central-1"
}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  version = "2.15.0"
}
