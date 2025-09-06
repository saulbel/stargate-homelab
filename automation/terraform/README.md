# 🌱 Terraform

Terraform is an Infrastructure as Code (**IaC**) tool that lets you declaratively provision and manage your homelab infrastructure.

---

## 🚀 Why Terraform?

- **Declarative:** Define your infrastructure in simple configuration files.
- **Multi-provider support:** Works with cloud, on-prem, and virtualization platforms.
- **Repeatable & versioned:** Track changes and roll back easily.
- **Community-powered:** Tons of modules and providers available.

For this project, we use the [`Proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest/docs) provider to automate VM and resource creation.

---

## 📦 Files Included

All my Terraform files for self-hosting are here and ready to use:

```
terraform
└── main.tf
└── provider.tf
└── variables.tf
```

---

## 🗄️ State Management

**Important:**  
Always secure your `.tfstate` file!  
You can use an S3 bucket (for example, with [MinIO](https://min.io/)) to store your state remotely and safely.

---

## 🛠️ To Improve

- Add automation to retrieve and start `docker-compose.yaml` files after provisioning.
- Find a way to avoid using `local-exec` and `remote-exec` for post-provisioning tasks.
- Add more examples and modularize resources for easier reuse.

---

> _Automate your infrastructure, one resource at a time!_