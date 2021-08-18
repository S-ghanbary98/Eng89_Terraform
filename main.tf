provider "aws" {
 region = "eu-west-1"

}





resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
 }
}




resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.209.1.0/24"
  availability_zone = var.AWS_REGION

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





resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eng89_shervin_terraform_IG"
  }
}


resource "aws_route_table" "prod-public-crt" {
    vpc_id = aws_vpc.terraform_vpc_code_test.id

    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "eng89_shervin_terr_RT"
    }
}

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id


  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "92.0.86.233/32"
      from_port  = 22
      to_port    = 22
    }



  ingress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }

  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }

  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "10.209.2.0/24"
      from_port  = 1024
      to_port    = 65535
    }

  tags = {
    Name = "eng89_shervin_terraform_public_NACL"
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
resource "aws_security_group" "private" {
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

    cidr_blocks = ["92.0.86.233/32"]
  }

  ingress {
    from_port = 27017
    to_port   = 27017
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
    Name = "eng89_shervin_terraform_priv"
  }
}




#app
resource "aws_instance" "app_instance" {
  ami = "ami-046036047eac23dc9"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.security_app.id]
  tags = {
      Name = "eng89_shervin_terraform_app"
  }
  key_name = var.key_name

}


#DB
resource "aws_instance" "app_instance2" {
  ami = "ami-0a2a0deac91474c88"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]
  tags = {
      Name = "eng89_shervin_terraform_db"
  }

  key_name = var.key_name

}
