# 🚀 stargate-homelab

Welcome to **stargate-homelab**!  
A modular, automated, and fun approach to building your own homelab using **Proxmox**, **Docker**, **Kubernetes**, and more.

---

## 🧰 Prerequisites

Before you start, make sure you have:
- **Spare hardware** (old PC, server, or VM host)
- **Time and curiosity** to experiment and learn!

---

## 📁 Project Structure

```
stargate-homelab
└── automation
    └── ansible    
    └── terraform
    └── scripts  
└── docker  
└── kubernetes
    └── argocd
└── observability
    └── prometheus  
└── proxmox
└── tailscale
```

---

## 🎯 Project Goals

The goal of this project is to build a homelab using **Proxmox** as the backbone, enabling you to run daily-use tools, experiment for work, or just have fun tinkering with new tech.

---
## 🏗️ Architecture Overview

![proxmox-oci](https://github.com/user-attachments/assets/b7e62e28-5a6d-44fb-b0c6-90f289c1c81d)
![homepage](https://github.com/user-attachments/assets/36d4a50f-627d-42a8-996e-558ea6a5a8f3)
![grafana](https://github.com/user-attachments/assets/345ac670-cfbb-4a97-8831-f0cd1f40d67f)

---

## ✨ Features

- **Automated infrastructure provisioning** with [Terraform](automation/terraform/README.md)
- **Configuration management** using [Ansible](automation/ansible/README.md)
- **Containerized services** with [Docker](docker/README.md)
- **Kubernetes cluster & GitOps** with [ArgoCD](kubernetes/argocd/README.md)
- **Centralized monitoring & logging** ([Prometheus](observability/prometheus/README.md), Loki, Grafana)
- **Secure networking** with [Tailscale](tailscale/README.md)
- **Proxmox-based virtualization** ([Proxmox](proxmox/README.md))

---

## 🚦 Getting Started

Follow these steps to set up your homelab:


1. **[Proxmox](./proxmox/README.md)**  
   Set up your virtualization platform.

2. **[Observability](./observability/prometheus/README.md)**  
   Monitor your infrastructure.

3. **[Docker](./docker/README.md)**  
   Run containerized apps.

4. **[Tailscale](./tailscale/README.md)**  
   Secure your network.

5. **[Automation](./automation/README.md)**  
   Automate deployments and configuration.

6. **[Kubernetes](./kubernetes/README.md)**  
   Orchestrate containers at scale.

---

## 🤝 Contributing

Want to help? Awesome!  
- Fork the repo
- Create your feature branch (`git checkout -b feature/fooBar`)
- Commit your changes
- Push to your branch
- Open a Pull Request

---

## 💬 Support & Feedback

Questions, suggestions, or want to share your setup?  
Open an issue and I will be gladly attend to it.

---

## 🚧 Next Steps

- Full documentation for every component so you can mirror the setup.
- Continuous improvements and new features—stay tuned!

---

> _Made with ❤️ for homelab enthusiasts!_
