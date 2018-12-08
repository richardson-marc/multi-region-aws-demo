terraform {
  required_version = ">= 0.10.3"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "default" {
  most_recent = true

  filter {
    name = "name"

    # this should pull down the latest OL 7.5 image
    values = ["OL7.5-x86_64-HVM-2018*"]
  }

  #  filter {
  #    name   = "architecture"
  #    values = ["x86_64"]
  #  }

  #  filter {
  #    name   = "virtualization-type"
  #    values = ["hvm"]
  #  }

  #  filter {
  #    name   = "root-device-type"
  #    values = ["ebs"]
  #  }

  #  owners = ["amazon"]
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  #  assign_generated_ipv6_cidr_block = "true"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "ovp-${var.region}-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "ovp-${var.region}-igw"
  }
}

resource "aws_subnet" "public" {
  #  count                           = "${length(data.aws_availability_zones.available.names)}"
  count      = "1"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"

  #  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false
  availability_zone               = "${element(data.aws_availability_zones.available.names, count.index)}"
}

resource "aws_route_table" "public" {
  #  count  = "${length(data.aws_availability_zones.available.names)}"
  count  = "1"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  #  route {
  #    ipv6_cidr_block = "::/0"
  #    gateway_id      = "${aws_internet_gateway.default.id}"
  #  }
}

resource "aws_route_table_association" "public" {
  #  count          = "${length(data.aws_availability_zones.available.names)}"
  count          = "1"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #  ingress {
  #    from_port        = -1
  #    to_port          = -1
  #    protocol         = "icmpv6"
  #    ipv6_cidr_blocks = ["::/0"]
  #  }
}

resource "aws_instance" "server" {
  #  count                  = "${length(data.aws_availability_zones.available.names) * var.servers_per_az}"
  count         = "1"
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.default.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  #  ipv6_address_count     = "1"
  vpc_security_group_ids = ["${aws_security_group.default.id}", "${aws_vpc.main.default_security_group_id}"]

  tags = {
    Name            = "ovp-${element(data.aws_availability_zones.available.names, count.index)}"
    EnvironmentName = "${var.env}"
    CostArea        = "${var.cost_area}"
    Squad           = "${var.squad}"

    #    FQDN            = "${var.substr1}${count.index+1}${var.substr3}"
    ProductCode = "${var.ProductCode}"
    Owner       = "${var.Owner}"
  }
}

# chef stuff
# By keeping this out of the  instance resource we can (with additional
# work) make chef-bootstrap conditional in the future
# resource "null_resource" "chef-bootstrap" {
#   count = "${var.chef_provision ? var.instance_count : 0}"


#   connection {
#     type        = "ssh"
#     user        = "${var.ssh_user}"
#     host        = "${element(oci_core_instance.TFInstance.*.private_ip, count.index)}"
#     private_key = "${file(var.ssh_private_key_path)}"
#   }


#   provisioner "remote-exec" {
#     inline = [
#       "export PATH=$PATH:/usr/bin",
#       # install nginx
# #      "sudo apt-get update",
#       "sudo yum install -y install nginx"
#     ]
#   }
# }

