# #learn-terraform
---

## Terraform is a tool for building, updating and versioning infrastructure with code.

Terraform is made up of two parts: Terraform Core and Terraform Plugins. The set of files used to describe infrastructure in Terraform is called as a Terraform configuration.

>>Terraform Core is the framework that abstracts away the details of plugin discovery and RPC communication so developers do not need to manage either. Terraform Plugins are responsible for the domain specific implementation of their type.

#### Terraform Plugins 
Terraform is built on a plugin-based architectures. These plugins are essentially the interfaces for services or provisioners. An example of a service would be AWS, and an example of a provisioner would be bash. You can have more than one plugin per infrastructure.

#### Terraform Core 

1. Plans the execution
2. Communicates with the plugins
3. Maintains the resource's state management 
4. Constructs the resource graph

Terraform Core is the framework that A static language written in Go. The compiled binary is the CLI, and makes remote procecdure calls to the plugins. The CLI is the entrypoint for using Terraform. The code is open source and hosted at github.com/hashicorp/terraform. Terraform core does the work of planning the execution, communicating with the plugins, maintaining the resource's state management and constructing the resource graph.

#### State
Terraform's cached information about your managed infrastructure and configuration. This state is used to persistently map the same real world resources to your configuration from run-to-run, keep track of metadata, and improve performance for large infrastructures.

Without state, Terraform has no way to identify the real resources it created during previous runs. Thus, when multiple people are collaborating on shared infrastructure, it's important to store state in a shared location.


# Credentials

Initializing your Terraform configuration to your AWS profile is done through IAM's Access Keys.

1. Open the [IAM panel](https://console.aws.amazon.com/iam/home?#security_credential) in your AWS console
2. Click on the `Access Keys` dropdown
3. Click on the `Create New Access Key` button
4. Click on Download Key File 
5. Open the downloaded file, and save the two config variables to `~/.aws/credentials`. 

To verify, [install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-linux-al2017.html) and run `aws configure`.

By default, Terraform will automatically search for saved credentials or IAM instance profile credentials. It's best practice to not save these credentials in any of your terraform files for **(a)** security purposes, but this also **(b)** allows for more than one admin user, as well as **(c)** having different IAM credentials for each user without having to modify the configuration files. 

You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively. Note that setting your AWS credentials using either these (or legacy) environment variables will override the use of AWS_SHARED_CREDENTIALS_FILE and AWS_PROFILE. The AWS_DEFAULT_REGION and AWS_SESSION_TOKEN environment variables are also used, if applicable:

```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
```
Shared Credentials file
You can use an AWS credentials file to specify your credentials. The default location is $HOME/.aws/credentials on Linux and OS X, or "%USERPROFILE%\.aws\credentials" for Windows users. If we fail to detect credentials inline, or in the environment, Terraform will check this location. You can optionally specify a different location in the configuration by providing the shared_credentials_file attribute, or in the environment with the AWS_SHARED_CREDENTIALS_FILE variable. This method also supports a profile configuration and matching AWS_PROFILE environment variable:

Usage:

provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/Users/tf_user/.aws/creds"
  profile                 = "customprofile"
}
If specifying the profile through the AWS_PROFILE environment variable, you may also need to set AWS_SDK_LOAD_CONFIG to a truthy value (e.g. AWS_SDK_LOAD_CONFIG=1) for advanced AWS client configurations, such as profiles that use the source_profile or role_arn configurations.

# Providers

The provider block configures the provider (such as AWS). It's important to note that you can have more than one provider per Terraform configuration. 

```
provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}
```


# Resources

The resource block relates directly to what the provider can manage. An example of a resource where the provider is AWS would be an EC2 instance or a VPC.

The resource block has two strings before opening the block: the resource type and the resource name. In our example, the resource type is "aws_instance" and the name is "example." The prefix of the type maps to the provider. In our case "aws_instance" automatically tells Terraform that it is managed by the "aws" provider.

Within the resource block itself is configuration for that resource. This is dependent on each resource provider and is fully documented within our providers reference. For our EC2 instance, we specify an AMI for Ubuntu (An AMI provides a software configuration for your instance.), and request a "t2.micro" instance so we qualify under the free tier.

```
# Create an EC2 Instance
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}" 
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}


# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```

# Variables

You can also use variable blocks to interpolate values.

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




#### Some resources
[getting started](https://learn.hashicorp.com/terraform/getting-started/build)
[terraform and aws](https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/)
[providers](https://www.terraform.io/docs/providers/index.html)
[remote state](https://www.terraform.io/docs/state/remote.html)


### Getting started
1. Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) on your machine.
2. Create an account on [AWS](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=header_signup&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start).



### Resources
* [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)


