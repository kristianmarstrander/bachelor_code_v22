terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.47.0"
    }
  }
}

variable "name" {  
  type = string  
  description = "Name of server"
}

provider "openstack" {
  cloud  = "openstack" # cloud defined in cloud.yml file
}

# Variables
variable "keypair" {
  type    = string
  default = "key01"   # name of keypair created 
}

variable "network" {
  type    = string
  default = "network01" # default network to be used
}

variable "security_groups" {
  type    = list(string)
  default = ["default"]  # Name of default security group
}

# Create an instance
resource "openstack_compute_instance_v2" "server" {
  name            = var.name  #Instance name
  image_id        = "4c1a9492-2fb0-4bbc-8f43-798ee0070553"
  flavor_id       = "1ff86526-c425-4b48-87ac-83826e1b7136"
  key_pair        = var.keypair
  security_groups = var.security_groups
  admin_pass      = "Cisco123!"
  network {
    name = var.network
  }
}

resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "ntnu-internal"
}

resource "openstack_compute_floatingip_associate_v2" "fip1" {
  floating_ip = openstack_networking_floatingip_v2.fip1.address
  instance_id = openstack_compute_instance_v2.server.id
}

# Output VM IP Addresses
output "server_private_ip" {
 value = openstack_compute_instance_v2.server.access_ip_v4
}
output "server_floating_ip" {
 value = openstack_networking_floatingip_v2.fip1.address
}

# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      unconfiguredWindowsHosts = openstack_networking_floatingip_v2.fip1.address
    }
  )
  filename = "../ansible/hosts"
}
