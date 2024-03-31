#---------------------------------------
# Автопоиск AMI id с помощью Data Source
#
# Find latest for all regions:
#   - Ubuntu 22.04
#   - Amazon Linux 2023
#   - Windows Server 2022 Base
#---------------------------------------

provider "aws" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_ami" "latest_windows_server_2022" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

# Always latest AMI for all regions
resource "aws_instance" "my_Ubuntu" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.nano"
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_windows_server_2022_ami_id" {
  value = data.aws_ami.latest_windows_server_2022.id
}

output "latest_windows_server_2022_ami_name" {
  value = data.aws_ami.latest_windows_server_2022.name
}
