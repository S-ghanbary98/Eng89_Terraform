provider "aws" {
 region = "eu-west-1"

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
