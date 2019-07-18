# #learn-terraform
---

###Terraform is a tool that allows developers to build, update and version infrastructure with code.

Terraform is built off of a plugin-based architure. It's split into two main components: Terraform Core and Terraform Plugins.

#### Terraform Core 
Uses remote procedure calls (RPC) to communicate with Terraform Plugins, and offers multiple ways to discover and load plugins to use. Terraform Core is a statically-compiled binary written in the Go programming language. The compiled binary is the command line tool (CLI) terraform, the entrypoint for anyone using Terraform. The code is open source and hosted at github.com/hashicorp/terraform.

###### The primary responsibilities of Terraform Core are:
* Infrastructure as code: reading and interpolating configuration files and modules
* Resource state management
* Construction of the Resource Graph
* Plan execution
* Communication with plugins over RPC

#### Terraform Plugins 
Exposes an implementation for a specific service, such as AWS, or provisioner, such as bash. Terraform Plugins are written in Go and are executable binaries invoked by Terraform Core over RPC. Each plugin exposes an implementation for a specific service, such as AWS, or provisioner, such as bash. All Providers and Provisioners used in Terraform configurations are plugins. They are executed as a separate process and communicate with the main Terraform binary over an RPC interface. Terraform has several Provisioners built-in, while Providers are discovered dynamically as needed (See Discovery below). Terraform Core provides a high-level framework that abstracts away the details of plugin discovery and RPC communication so developers do not need to manage either. Terraform Plugins are responsible for the domain specific implementation of their type.

###The set of files used to describe infrastructure in Terraform is called as a Terraform configuration.


### Getting started
1. Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) on your machine.
2. Create an account on [AWS](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=header_signup&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start).



### Resources
* [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)


