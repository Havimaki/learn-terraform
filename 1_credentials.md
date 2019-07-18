## Configuration
---
#### Credentials

Initializing your Terraform configuration to your AWS profile is done through IAM's Access Keys.

1. Open the [IAM panel](https://console.aws.amazon.com/iam/home?#security_credential) in your AWS console
2. Click on the `Access Keys` dropdown
3. Click on the `Create New Access Key` button
4. Click on Download Key File 
5. Open the downloaded file, and save the two config variables to `~/.aws/credentials`. 

To verify, [install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-linux-al2017.html) and run `aws configure`.

By default, Terraform will automatically search for saved credentials or IAM instance profile credentials. It's best practice to not save these credentials in any of your terraform files for **(a)** security purposes, but this also **(b)** allows for more than one admin user, as well as **(c)** having different IAM credentials for each user without having to modify the configuration files. 


#### Some resources
[getting started](https://learn.hashicorp.com/terraform/getting-started/build)
[terraform and aws](https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/)
[providers](https://www.terraform.io/docs/providers/index.html)
[remote state](https://www.terraform.io/docs/state/remote.html)



