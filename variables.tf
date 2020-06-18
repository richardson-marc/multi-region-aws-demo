variable "offset" {
  description = "allows for skipping numbers in hostname assignment for node number"
  default     = 0
}



variable "instance_type" {
  default = "t2.nano"
}

# Instance attributes
variable "instance_count" {
  description = "the number of compute instances to launch"
  default     = 2
}



variable "display_name" {
  description = "The friendly human readable name of the instance; can be changed"
  default     = "TFInstance"
}




variable "assign_public_ip" {
  description = "If in a public subnet, should a public IP be assigned; default true. For private subnets, this should be changed to false"
  default     = false
}

variable "ssh_user" {
  description = "Username of the user that will have initial SSH access to the instance."
  default     = "centos"
}

variable "ssh_public_key" {
  description = "The content of the public key used to connect to the Instance"
  default     = "~/.ssh/burst_id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "SSH private key that matches the ssh_public_key."
  default     = "~/.ssh/burst_id_rsa"
}

