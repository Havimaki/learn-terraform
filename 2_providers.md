#### Providers

A provider is responsible for creating and managing resources. The provider block is used to configured the named provider. It's important to note that you can have more than one provider per Terraform configuration.

```
provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}
```