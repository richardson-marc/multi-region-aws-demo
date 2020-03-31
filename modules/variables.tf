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

# Initial SSH access for provisioing and chef bootstrapping
variable "ssh_user" {
  # TODO: this should be a map for default user based on OS
  description = "Username of the user that will have initial SSH access to the instance."
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "The content of the public key used to connect to the Instance"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "SSH private key that matches the ssh_public_key."
  default     = "~/.ssh/id_rsa"
}

variable "BootStrapFile" {
  description = "user data file used by Cloud Init"
  default     = "./userdata/bootstrap"
}

# Storage
variable "blk_name" {
  description = "a prefix to add to the displayname of the block storage"
  default     = "blk"
}

variable "attach_volume" {
  description = "The number of volumes to attach to an instance; 1 .. 32"
  default     = "1"
}

variable "volume_size" {
  description = "the size of the volume to select from the volume_sizes map"
  default     = "100GB"
}

variable "volume_sizes" {
  description = "A map of common volume sizes in MBs"
  type        = "map"

  default = {
    "100GB" = "100"
    "256GB" = "256"
    "1TB"   = "1000"
    "2TB"   = "2000"
  }
}

