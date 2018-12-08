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

# ===================================================================
#                         Chef Configuration
# ===================================================================
variable "chef_provision" {
  description = "boolean to trigger chef provisioning; defaults to true"
  default     = true
}

variable "chef_server_url" {
  description = "Protocol + URL of the Chef server (eg. https://chef.example.com)."
  default     = "https://chef.dynback.net"
}

variable "chef_client_version" {
  description = "Version of chef-client to install on instance."
  default     = "12.13.37"
}

variable "chef_validation_client_name" {
  description = "Name of the Validation Client for Chef (must match the Validation Key)."
  default     = "username"
}

variable "chef_validation_key_path" {
  description = "Local path to the Validation Client Key for Chef (required)."
  default     = "~/.chef/keys/mrichardson.pem"
}

variable "chef_org_name" {
  description = "Target chef organization to bootstrap instance into."
  default     = "kaizen"
}

variable "chef_org_environment" {
  description = "Target Chef organization's environment to use when deploying."
  default     = "0_1_LATEST"
}

variable "chef_encrypted_data_bag_secret" {
  description = "Local path to encrypted data bag secret."
  default     = "~/.chef/encrypted_data_bag_secret.pem"
}

variable "chef_run_list" {
  description = "Chef run list to be provided to each node in the cluster."
  default     = ["_base::full"]
}

variable "domain" {
  description = "Domain name assigned to the node['dyn']['domain'] attribute."
  default     = "oci.dynback.net"
}

variable "cost_area" {
  description = "cost area"
  default     =	"61620"
}

variable "squad" {
  description = "squad"
  default     =	"groan chomskies"
}

variable "ProductCode" {
  description = "product code"
  default     =	"31"
}

variable "Owner" {
  description	  =	"owner"
  default	   =	"groanchomskies+pvp@dyn.com"
}

variable "env" {
  description  =	"environment"
  default      =	"integration"
}