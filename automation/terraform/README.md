# Terraform

Terraform is an Infrastructure as Code (**IaC**) tool that lets you declaratively provision and manage your homelab infrastructure.

---

## Why Terraform?

I don't want to click through the Proxmox UI every time I need a new VM or LXC. With Terraform I describe the node once (IP, resources, provisioners) and can tear it down and rebuild it identically in minutes if I break something testing.

For this project, I use the [`Proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest/docs) provider to automate LXC creation.

Kubernetes clusters are **not** created here anymore: Rancher provisions their VMs on Proxmox through a node driver (see [Kubernetes](/kubernetes/README.md)).

---

## Files Included

All my Terraform files for self-hosting are here and ready to use:

```
terraform
└── lxc.tf
└── provider.tf
└── variables.tf
```

---

## State Management

**Important:**  
The state is local (no `backend` block) and gitignored, together with `secrets.auto.tfvars`. Back up `terraform.tfstate` yourself.  
The provider lock file `.terraform.lock.hcl` is tracked, so `terraform init` uses the same provider versions and hashes on each machine.  
A remote S3 backend (for example, on [MinIO](/docker/minio)) is an option for later.

---

## To Improve

- Add automation to retrieve and start `docker-compose.yaml` files after provisioning.
- Find a way to avoid using `local-exec` and `remote-exec` for post-provisioning tasks.
- Add more examples and modularize resources for easier reuse.