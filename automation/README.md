# Automation

This folder contains all the automation tools and scripts used to provision, configure, and manage your homelab infrastructure.

---

## Project Structure

```
automation
└── ansible
└── terraform
```

---

## Components

- **[Ansible](./ansible)** : Automate configuration and application deployment across your vms and containers.  

- **[Terraform](./terraform)** : Provision and manage **Proxmox** infrastructure resources declaratively.  

---

## Getting Started

1. **Review prerequisites**  
   Make sure you have Ansible and Terraform installed on your control machine.

2. **Customize variables**  
   Ansible has no variable files. Terraform needs a gitignored `secrets.auto.tfvars` in `terraform` with these variables: `proxmox_node_url`, `proxmox_node_name`, `proxmox_user`, `proxmox_password`, `proxmox_ssh_key`, `ansible_ssh_key` and `tailscale_auth_key`.

3. **Run automation**  
   - Use Terraform to provision infrastructure.
   - Use Ansible to configure and deploy services.