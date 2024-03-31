provider "aws" {}

# заглушка под ресурс
resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 8.8.8.8"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python3", "-c"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Petya"
      NAME3 = "Kolya"
    }
  }
}

resource "aws_instance" "myserver" {
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.nano"
  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creations!"
  }
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }

  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4]
}
