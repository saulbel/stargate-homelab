# ⚙️ Ansible

Ansible is a powerful automation tool for configuring, deploying, and updating software across your infrastructure.

---

## 🚀 Why Ansible?

- **Agentless:** No need to install anything on your managed nodes.
- **Simple YAML syntax:** Easy to write and understand playbooks.
- **Idempotent:** Ensures consistent results every run.
- **Extensible:** Supports roles, modules, and plugins.

---

## 📦 Playbooks Included

All my Ansible playbooks for self-hosting are here and ready to use:

```
ansible
└── install-and-configure-firewalld.yaml
└── install-and-configure-ufw.yaml
└── install-docker-debian.yaml
└── install-docker-ubuntu.yaml  
└── install-tools.yaml 
└── reboot-host.yaml 
```

- **Firewall setup:** `firewalld` and `ufw`
- **Docker installation:** For Debian and Ubuntu
- **Essential tools:** Common utilities for your hosts
- **Host management:** Reboot and maintenance tasks

---

## ☸️ Kubernetes (K3s)

Want to set up a self-hosted, highly available Kubernetes cluster?  
Check out [techno-tim/k3s-ansible](https://github.com/techno-tim/k3s-ansible), the repo I use in my **Terraform** config for K3s cluster setup.

---

## 🖥️ Centralized Management

For managing playbooks at scale, consider:
- [Semaphore](https://github.com/ansible-semaphore/semaphore)
- [AWX/Tower](https://github.com/ansible/awx)

I've experimented with these, but currently don't have an active use case.

---

## 🛠️ To Improve

- Add more playbooks for common tasks and services
- Organize playbooks into roles for better reusability
- Add example inventory files and usage instructions

---

> _Automate your homelab, one playbook at a time!_