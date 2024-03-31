provider "aws" {
}

resource "aws_instance" "my_Ubuntu" {
  count         = 3
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.nano"
  subnet_id     = "subnet-0aea57da48cda14ba"
}

resource "aws_instance" "my_Amazon" {
  ami           = "ami-0f403e3180720dd7e"
  instance_type = "t2.nano"
  subnet_id     = "subnet-0aea57da48cda14ba"
}
