data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

resource "aws_instance" "this" {
  # for_each = toset(["one", "two", "three"])
  count = length(var.three_ec2s)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "adimsi"
  vpc_security_group_ids = ["sg-00c8b561dc6b524c6"]
  # user_data = file("${path.module}/script.sh")
  # If i want to use tabs for readabality, use <<-EOF and EOF to start and end the block
  # - will ignore tabs at begining of linse but not spaces
  user_data              = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip
sudo apt install -y python3
sudo apt install -y python3-venv
sudo apt  install -y awscli
sudo apt install -y tree
  EOF
  ebs_block_device {
    device_name           = "/dev/xvdb"        # Mount point inside EC2
    volume_size           = 8                 # Size in GB
    volume_type           = "gp3"              # General Purpose SSD
    delete_on_termination = true               # Auto-delete on instance termination
  }
  iam_instance_profile = "EC2FULLACCESS"

  tags = {
    Name = "${var.three_ec2s[count.index]}-instance"
  }


}