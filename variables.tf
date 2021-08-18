variable "AWS_REGION" {
    default = "eu-west-1"
}

variable "name" {
  default="eng89_shervin_terraform_app"
}


variable "vpc_name" {
  default = "eng89_shervin_terr_vpc"
}
variable "cidr_block" {
  default="10.209.0.0/16"
}


variable "key_name" {

  default = "eng89_shervin"
}
