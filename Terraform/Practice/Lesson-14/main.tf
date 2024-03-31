#------------------------------------------------------------------
# Управление порядком создания ресурсов
#
# По умолчанию - одновременно, если выставить порядок - depends_on
#------------------------------------------------------------------

provider "aws" {
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_instance" "my_webserver_web" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0aea57da48cda14ba"
  key_name               = "Alexey_Tozik"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server_Web"
  }

  depends_on = [aws_instance.my_webserver_db, aws_instance.my_webserver_app]
}

resource "aws_instance" "my_webserver_app" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0aea57da48cda14ba"
  key_name               = "Alexey_Tozik"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server_Application"
  }

  depends_on = [aws_instance.my_webserver_db]
}

resource "aws_instance" "my_webserver_db" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0aea57da48cda14ba"
  key_name               = "Alexey_Tozik"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server_Database"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first security group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tpc"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "Alexey Tozik"
  }
}
