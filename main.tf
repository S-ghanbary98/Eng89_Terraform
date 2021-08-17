
provider "aws" {
    region = "${var.AWS_REGION}"
}


resource "aws_vpc" "main" {
  cidr_block = "10.209.0.0/16"


  tags = {
    Name = "eng89_shervin_terr_vpc"

 }
}




resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.209.1.0/24"

  tags = {
    Name = "eng89_shervin_terraform"
  }
}




resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.209.2.0/24"

  tags = {
    Name = "eng89_shervin_private_terraform"
  }
}






resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eng89_shervin_terraform_IG"
  }
}
