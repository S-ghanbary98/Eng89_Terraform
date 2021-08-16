# Terraform

![Diagram](terraform-config-files-e1605834689106.png)

###### What is Terraform?

- Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently.

## Installing Terraform

- Terraform Can be installed on mac via the following commands, after which you should run `terraform --version` to check if successful. Information for other operating systems can be seen below.

[Operating System Installation]: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
brew upgrade hashicorp/tap/terraform

```

## Launching an Ec2 Instance

- To launch an ec2 instance we need to initialize the information for the EC2 in a new file. In this case the information for the EC2 is contained within the `main.tf` file. The main.tf file can be seen below.

```
# building a script to connect to aws and download/setup all dependecies
# keyword: provider aws

 provider "aws" {
        region = "eu-west-1"


}

# terraform init 
# launch aws services
# Let's launch an EC2 instance in eu-west-1
# The keyword is resource and provide the resource name and give the name with specific details of the service

resource "aws_instance" "app_instance" {


# resource aws_ece_instance, name as eng89_shervin_terraform, ami, type of instance, with , without IP


# Provide valid AMI
ami = "ami-038d7b856fe7557b3"

# pem file name
key_name = "eng89_shervin"



# whats the type of instance
instance_type = "t2.micro"



# We would like public IP for this instance
associate_public_ip_address=true


# TAGS

tags = {
       
       Name = "eng89_shervin_terraform"
 }
}



# Most common commands for terrraform:
# Terraform plan check the syntac and validates instructions we have provided in the script.

```

- We next have to ensure we input our aws_secret_access_key and aws_access_key are environment variables.
- We do this using the `EXPORT` command.
- Once completed we can go ahead and initialize terraform using `terraform init`. 
- Finnally we can create the instance using the command `terraform apply`.
- If we wish to destroy the Ec2 instance we can do this via the command `terraform destroy`.








