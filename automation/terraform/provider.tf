terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.73.2"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_node_url
  username = var.proxmox_user
  password = var.proxmox_password
  insecure = true
  tmp_dir  = "/var/tmp"
}