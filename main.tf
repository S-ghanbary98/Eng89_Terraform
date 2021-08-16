
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

