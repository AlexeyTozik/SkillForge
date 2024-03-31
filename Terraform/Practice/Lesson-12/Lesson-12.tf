#----------------------------
# LifeCycle
#
#
#
#----------------------------

provider "aws" {
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0aea57da48cda14ba"
  key_name               = "Alexey_Tozik"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Alexey",
    l_name = "Tozik",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Bugatti", "Katya"]
  })

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Alexey Tozik"
  }

  #   lifecycle {
  #     prevent_destroy = true
  #   }

  #   lifecycle {
  #     ignore_changes = ["ami", "user_data"]
  #   }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first security group"

  # Incoming traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outcoming traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Alexey Tozik"
  }
}
