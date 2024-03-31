#----------------------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#----------------------------------------------------------
provider "aws" {
  region = "es-east-1"
}


resource "aws_iam_user" "user1" {
  name = "pushkin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#----------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.nano"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}
