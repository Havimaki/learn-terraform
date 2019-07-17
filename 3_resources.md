#### Resources

The resource block defines a resource that exists within the infrastructure. A resource might be a physical component such as an EC2 instance, or it can be a logical resource such as a Heroku application.

The resource block has two strings before opening the block: the resource type and the resource name. In our example, the resource type is "aws_instance" and the name is "example." The prefix of the type maps to the provider. In our case "aws_instance" automatically tells Terraform that it is managed by the "aws" provider.

Within the resource block itself is configuration for that resource. This is dependent on each resource provider and is fully documented within our providers reference. For our EC2 instance, we specify an AMI for Ubuntu, and request a "t2.micro" instance so we qualify under the free tier.