terraform {
  required_version = ">= 0.10.3"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "burst-key" {
  key_name   = "burst-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDY1DE9tyhhe0BKDVTPM546oby4sSRD0+PjovBlQW2a1H0AkQ4r3RpqP26JGY8bG1nJdyCIbh3HwRgzYvmLwasRaxOkw7K6YSKa06QQfsDPRoDs5bJB75jLv/MnYMeFYto/trIdJTj/16wcgsUWlTjCsok4exCMQCxkv8wChzV0H53ZIrXnfnRr2E/RvdtiNXD5d5rfFo4WRcusyJ9+TChD0O6tAG1PMRtmVgTmeiCIFe7Lj6aVCDn4gn0p95den/az6jBwtWvJKA1k6dzFJCW2dD7PP67j1CiyX2VfVTIdjrtAa4Mo1k1+U3vjz22IBpGFR+UPKy2u0xkMiVDyEFtH marc@lk.local"
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
  count      = "2"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"

  #  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false
  availability_zone               = "${element(data.aws_availability_zones.available.names, count.index)}"
}

resource "aws_route_table" "public" {
  count  = "1"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

}

resource "aws_route_table_association" "public" {

  count          = "2"
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
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "server" {
 timeouts {
    create = "60m"
    delete = "2h"
  }
key_name      = "burst-key"
  count         = "2"
  instance_type = "${var.instance_type}"
  ami           = "ami-01ca03df4a6012157"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  #  ipv6_address_count     = "1"
  vpc_security_group_ids = ["${aws_security_group.default.id}", "${aws_vpc.main.default_security_group_id}"]

  tags = {
    Name 	    = "server${format("%01d", count.index+1)}"
  }



}

resource "aws_elb" "foo" {
  name            = "foo"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}"]

  instances = ["${aws_instance.server.*.id}"]
listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}