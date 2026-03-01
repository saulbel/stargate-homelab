variable "proxmox_node_url" {
  description = "Proxmox API endpoint URL"
  type        = string
}

variable "proxmox_node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox API user"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox API password"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_key" {
  description = "SSH public key for Proxmox access"
  type        = string
}

variable "ansible_ssh_key" {
  description = "SSH public key for Ansible access"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type        = string
  sensitive   = true
}