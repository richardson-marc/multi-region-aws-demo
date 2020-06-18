
output "instance_ips" {
# I think this should work, but does not, so I just set it to "1" :(
#value = aws_instance.server.*.public_ip
  value = "1"
}

output "ssh_user" {
  value = "${var.ssh_user}"
}

output "ssh_key" {
  value = "${var.ssh_private_key_path}"
}

