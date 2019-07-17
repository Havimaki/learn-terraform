## Updating
As you change Terraform configurations, Terraform builds an execution plan that only modifies what is necessary to reach your desired state.

By using Terraform to change infrastructure, you can version control not only your configurations but also your state so you can see how the infrastructure evolved over time.

The prefix -/+ means that Terraform will destroy and recreate the resource, rather than updating it in-place. While some attributes can be updated in-place (which are shown with the ~ prefix), changing the AMI for an EC2 instance requires recreating it. Terraform handles these details for you, and the execution plan makes it clear what Terraform will do.

Additionally, the execution plan shows that the AMI change is what required resource to be replaced. Using this information, you can adjust your changes to possibly avoid destroy/create updates if they are not acceptable in some situations.