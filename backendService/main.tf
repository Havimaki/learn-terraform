/** 
=============================================================================================
In this file, we will set up our  AMI (Amazon Machine Image) and the EC2 instance
We won't worry about any roles or policies just yet, and instead focus on learning Terraform 
and how it works as a templating language that builds the infrastructure.
============================================================================================= 
**/

/**
A data source returns data without actually creating anything
If instead you wanted to create and manage a custom AMI, you would use a resource block.
https://www.terraform.io/docs/providers/aws/d/ami.html

The following fields include:
1. most_recent: 
if more than one AMI is returned, use the most recent one.

2. Filters: 
This limits the search. You can check https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html to see a full list of fields that describe an AMI. In this case we are limiting to search to a HVM (hardware virtual machine) with the name ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]. Notice how the filter value is an array. An easy way to distinguish if something should be an array, is simply by seeing if the key name is plural. In this case, a filter requires a name and value field. Value is pluralized to values, so you can start off by assuming that it can take more than one value, in which case we would need to pass it in as an array. 

2. The owner: 
This is the only required field. It's a list of AMI owners to limit the search. A valid value would be an AWS account ID, self (the current account), or an AWS owner alias (e.g. amazon, aws-marketplace, microsoft). In this case we are using Canonical, who produce Ubuntu.
**/
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

/**
A resource builds a component  integral to the provider, in this case AWS. 
Here we are creating an EC2 instance (AKA an aws instance)
https://www.terraform.io/docs/providers/aws/r/instance.html

A few things to notice:
1. We pass in the result of the data source above.
2. We interpolate the value of aws_ami.ubuntu and use its id to specify the AMI 
3. We use  the id of the AMI instead of the ARN (Amazon Resource Name). 
    This is because there is no unique resource for this ubuntu server. Think of it as a Dockerfile, 
    when we build on top of the latest Node js. If instead We wanted to created a custom AMI, you would use a resource block.

Here we've passed in three fields.
1. ami:
This is a required field, otherwise the ec2 would not be able to be created.

2. instance_type:
This is also required. You can also try creating an EC2 intance in the aws console, and see the steps required along the way, to get a better feel for why this is required. If AWS doesn't know which size, it can't properly configure the instance. 

3. tags:
this is optional, but generally recommended. You can use tags to specify and add more details to an instance. You can use tags to group specific instances together, or even just for readablity sake. For example, here I could name the instance learn-terraform, or learn-terraform-web. Or i can keep the name as simple as possible and integral to its functional purpose, and specify in the tags what this instance named web is used for. THe key (in this case, Name) can be named anything. Think of it as a key/value pair that you initialized. 
**/
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"                  # Required

  tags = {
    Name = "Learn Terraform"
  }
}
