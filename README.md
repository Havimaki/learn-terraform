# #learn-terraform
---

## Terraform is a tool for building, updating and versioning infrastructure with code.

Terraform is made up of two parts: Terraform Core and Terraform Plugins. The set of files used to describe infrastructure in Terraform is called as a Terraform configuration.

>>Terraform Core is the framework that abstracts away the details of plugin discovery and RPC communication so developers do not need to manage either. Terraform Plugins are responsible for the domain specific implementation of their type.

#### Terraform Core 

Terraform Core is the framework that A static language written in Go. The compiled binary is the CLI, and makes remote procecdure calls to the plugins. The CLI is the entrypoint for using Terraform. The code is open source and hosted at github.com/hashicorp/terraform. Terraform core does the work of planning the execution, communicating with the plugins, maintaining the resource's state management and constructing the resource graph.

#### Terraform Plugins 
Terraform is built on a plugin-based architectures. These plugins act as the interfaces for services or provisioners. An example of a service would be AWS, and an example of a provisioner would be bash. It is possible to have more than one plugin per infrastructure.

#### State
Terraform's cached information about your managed infrastructure and configuration. This state is used to persistently map the same real world resources to your configuration from run-to-run, keep track of metadata, and improve performance for large infrastructures.

Without state, Terraform has no way to identify the real resources it created during previous runs. Thus, when multiple people are collaborating on shared infrastructure, it's important to store state in a shared location, like a free Terraform Enterprise organization.


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


# Initialization
The first command to run for a new configuration -- or after checking out an existing configuration from version control -- is terraform init, which initializes various local settings and data that will be used by subsequent commands.

Terraform uses a plugin based architecture to support the numerous infrastructure and service providers available. As of Terraform version 0.10.0, each "Provider" is its own encapsulated binary distributed separately from Terraform itself. The terraform init command will automatically download and install any Provider binary for the providers in use within the configuration, which in this case is just the aws provider.

The aws provider plugin is downloaded and installed in a subdirectory of the current working directory, along with various other book-keeping files.

The output specifies which version of the plugin was installed, and suggests specifying that version in configuration to ensure that running terraform init in future will install a compatible version. This step is not necessary for following the getting started guide, since this configuration will be discarded at the end.

his output shows the execution plan, describing which actions Terraform will take in order to change real infrastructure to match the configuration. The output format is similar to the diff format generated by tools such as Git. The output has a + next to aws_instance.example, meaning that Terraform will create this resource. Beneath that, it shows the attributes that will be set. When the value displayed is (known after apply), it means that the value won't be known until the resource is created.

If terraform apply failed with an error, read the error message and fix the error that occurred. At this stage, it is likely to be a syntax error in the configuration.

If the plan was created successfully, Terraform will now pause and wait for approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure. In this case the plan looks acceptable, so type yes at the confirmation prompt to proceed.

Terraform also wrote some data into the terraform.tfstate file. This state file is extremely important; it keeps track of the IDs of created resources so that Terraform knows what it is managing. This file must be saved and distributed to anyone who might run Terraform. 

You can inspect the current state using terraform show.

You can see that by creating our resource, we've also gathered a lot of information about it. These values can actually be referenced to configure other resources or outputs, which will be covered later in the getting started guide.

# Updating
As you change Terraform configurations, Terraform builds an execution plan that only modifies what is necessary to reach your desired state.

By using Terraform to change infrastructure, you can version control not only your configurations but also your state so you can see how the infrastructure evolved over time.

The prefix -/+ means that Terraform will destroy and recreate the resource, rather than updating it in-place. While some attributes can be updated in-place (which are shown with the ~ prefix), changing the AMI for an EC2 instance requires recreating it. Terraform handles these details for you, and the execution plan makes it clear what Terraform will do.

Additionally, the execution plan shows that the AMI change is what required resource to be replaced. Using this information, you can adjust your changes to possibly avoid destroy/create updates if they are not acceptable in some situations.


# Destroying

Destroying your infrastructure is a rare event in production environments. But if you're using Terraform to spin up multiple environments such as development, test, QA environments, then destroying is a useful action.

Resources can be destroyed using the terraform destroy command, which is similar to terraform apply but it behaves as if all of the resources have been removed from the configuration.

The - prefix indicates that the instance will be destroyed. As with apply, Terraform shows its execution plan and waits for approval before making any changes.

Just like with apply, Terraform determines the order in which things must be destroyed. In this case there was only one resource, so no ordering was necessary. In more complicated cases with multiple resources, Terraform will destroy them in a suitable order to respect dependencies, as we'll see later in this guide.

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


