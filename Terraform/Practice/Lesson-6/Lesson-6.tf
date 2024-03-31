provider "aws" {
}

resource "aws_instance" "my_Ubuntu" {
  count         = 3
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.nano"
  subnet_id     = "subnet-0aea57da48cda14ba"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Alexey Tozik"
    Project = "Terraform Lessons"
  }
}

resource "aws_instance" "my_Amazon" {
  ami = "ami-0f403e3180720dd7e"
  # t2.nano -> t2.micro (stop -> change -> start with new type)
  instance_type = "t2.micro"
  subnet_id     = "subnet-0aea57da48cda14ba"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Alexey Tozik"
    Project = "Terraform Lessons"
  }
}

# Если пользователи добавили что-то от себя, при запуске terraform apply, он всё переделывает на прописаную в нём конфигурацию
