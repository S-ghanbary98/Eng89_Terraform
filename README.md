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


## Launching a VPC

- In this task we will be creating our own VPC network.
- The VPC will have a private, public and bastion servers.
- Route Tables, Internet gateways, NACL's and Security groups will also be created.


#### VPC Creation

- The vpc was created by modifying the main.tf file to contain the following, which initialises the VPC.

```python
resource "aws_vpc" "main" {
  cidr_block = "10.209.0.0/16"

  tags = {
    Name = "eng89_shervin_terr_vpc"
 }
}
```


#### Subnets

- The private and public subnets where created via the following code. 
- The private subnet has an IPV4 of 10.209.2.0/24, and the public has an IPV4 of 10.209.1.0/24.

```python
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.209.1.0/24"
  availability_zone = "${var.AWS_REGION}"

  tags = {
    Name = "eng89_shervin_terraform"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.209.2.0/24"
  availability_zone = "${var.AWS_REGION}"

  tags = {
    Name = "eng89_shervin_private_terraform"
  }
}
```


#### Creating an Internet Gateway

- The internet gateway was created Via the following.
- It is attached to the VPC via `vpx_id`

```python
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eng89_shervin_terraform_IG"
  }
}
```

#### Routing Table



#### Network ACL



#### Security Groups

- Two security groups need to be created both for the APP and DB respectively.
- The Security group for the app can be seen below.
- The app allows SSH, HTTP and a connection for port 3000 where nginx will be run.
- All traffic will be allowed in the outbound rules.

```python
resource "aws_security_group" "security_app" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  //If you do not add this rule, you can not reach the NGIX
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eng89_shervin_terraform_pub"
  }
}
```

#### Running New Ec2 Instance

- We can run a new instance with the new VPC configuration.
- This can be seen below.

```python
resource "aws_instance" "app_instance" {
  ami = "ami-046036047eac23dc9"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.security_app.id]
  tags = {
      Name = "eng89_shervin_terraform_app"
  }
  key_name = "eng89_shervin"

}

```