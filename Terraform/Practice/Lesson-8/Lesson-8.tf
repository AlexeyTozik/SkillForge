#---------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Alexis Bugatti
#---------------------------------------

provider "aws" {
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 AMI
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0aea57da48cda14ba"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = <<EOF
#!/bin/bash
sudo apt update
sudo apt install apache2 -y
myip=`curl ifconfig.me`
echo "<h2>Server with IP: $myip</h2>Build by Terraform!" > /var/www/html/index.html
sudo service apache2 start
sudo systemctl enable apache2
EOF

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Alexey Tozik"
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
