#### Variables

You can take it a step further and use variable blocks to interpolate values.

For the providers, you can update the codeblock to the following:

```
variable "aws_profile" {
  description = "The AWS profile."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "ca-central-1"
}

provider "aws" {
  profile    = "${var.aws_profile}"
  region     = "${var.aws_region}"
}
```

And you can update your resource block to the following:
```
resource "aws_iam_role_policy" "instance-config" {
  policy = "${module.config-bucket.read_policy_json}"
  role   = "${local.instance_profile_role}"
}
```

As is the case with all codebases, the use of variables is very useful in keeping the codebase clean and organized. You will see later the use of `modules` which can specify grouped configurations that can be used across multiple resources. 