variable "offset" {
  description = "allows for skipping numbers in hostname assignment for node number"
  default     = 0
}

variable "region" {
  description = "region"
}

#variable "region_id" {
#  description = "The region where the instance is being launched, for e.g us-ashburn-1"
#}

variable "instance_type" {
  default = "t2.micro"
}

# Instance attributes
variable "instance_count" {
  description = "the number of compute instances to launch"
  default     = 1
}

variable "hostname_label" {
  description = "The DNS hostname for the instance; can not be changed"
  default     = "tf-instance"
}

variable "display_name" {
  description = "The friendly human readable name of the instance; can be changed"
  default     = "TFInstance"
}

variable "InstanceShape" {
  default = "VM.Standard1.2"
}

variable "image_id" {
  type        = "string"
  description = "The OCID of the Image you want to launch; defaults to 'Canonical-Ubuntu-16.04-2017.10.25-0'"
  default     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaairsqycugtkqkah7ognnnaugbe5t2dbb62cqwnhbc5lnfpyhge4eq"
}

variable "assign_public_ip" {
  description = "If in a public subnet, should a public IP be assigned; default true. For private subnets, this should be changed to false"
  default     = false
}

variable "ssh_user" {
  description = "Username of the user that will have initial SSH access to the instance."
  default     = "centos"
}

