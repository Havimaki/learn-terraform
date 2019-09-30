/** 
=============================================================================================
In this file, we will set up the provider used for this project, in our case AWS
We won't worry about any roles or policies just yet, and instead focus on learning Terraform 
and how it works as a templating language that builds the infrastructure.
============================================================================================= 
**/

/**
In terraform this a variable block, which you can use to declare a variable. 
We don't have to use a variable block, but I'm using it here to show you how it works.
In other scenarios, variables are useful for addig a description and setting up a default value
**/
variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "ca-central-1"
}

/**
Here is where we set up the actual provider, in our case AWS.
The provider block is required before running terraform init, otherwise it won't know what to initialize.
Three fields are passed in:
1. profile:
Authentication is required, but it doens't have to be in the form of the profile key. Here you can find the steps to retrieve your acces key and secret key. https://help.bittitan.com/hc/en-us/articles/115008255268-How-do-I-find-my-AWS-Access-Key-and-Secret-Access-Key-.
There are four ways to set the profile/authenticate.
    1. Static credentials:
    access_key = "my-access-key"
    secret_key = "my-secret-key"

    2. Environment variables
    specifying the above static credentials in an env file

    3. Shared credentials file
        specifying the above static credentials on your machine. The default path is ~/.aws/credentials. If no static credentials are present, and nothing in the environment file, then Terraform by default will look here. If you don't want to store the credentials in that location, you can specify it with the following field:
        `shared_credentials_file = "/Users/tf_user/.aws/creds"`

    4. EC2 Role
    You can also assume the EC2 role by embedding the following block into the provider block:
    assume_role {
      role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
      session_name = "SESSION_NAME"
      external_id  = "EXTERNAL_ID"
    }

2. region:
This is a required field. THis is where you will specify which region to build the resources in. 

3. version:
This is a required field. You can see the changelog/release log of the aws provider here: https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md. In this case, I've just specified the most recent version. 
**/
provider "aws" {
  AWS_ACCESS_KEY_ID = "xxxxx"
  AWS_SECRET_KEY_ID = "xxxxx"
  region            = "${var.aws_region}"
  version           = "2.30.0"
}
