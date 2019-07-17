## Destroying

Destroying your infrastructure is a rare event in production environments. But if you're using Terraform to spin up multiple environments such as development, test, QA environments, then destroying is a useful action.

Resources can be destroyed using the terraform destroy command, which is similar to terraform apply but it behaves as if all of the resources have been removed from the configuration.

The - prefix indicates that the instance will be destroyed. As with apply, Terraform shows its execution plan and waits for approval before making any changes.

Just like with apply, Terraform determines the order in which things must be destroyed. In this case there was only one resource, so no ordering was necessary. In more complicated cases with multiple resources, Terraform will destroy them in a suitable order to respect dependencies, as we'll see later in this guide.