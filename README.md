# 🌌 Stargate Homelab

A modular, automated, and exploration‑ready homelab powered by **Proxmox**, **Terraform**, **Ansible**, **Docker**, **Kubernetes**, and more.

Inspired by production‑grade infrastructure patterns — but built for learning, tinkering, and having fun.

---
## ☑️ Prerequisites

Before you start, make sure you have:
- **Spare hardware** (old PC, server, or VM host)
- **Time and curiosity** to experiment and learn!

---
## 📁 Repository Structure
```
stargate-homelab
└── automation
    └── ansible    
    └── terraform
└── docker  
└── kubernetes
    └── argocd
└── observability
    └── prometheus  
└── pictures
└── proxmox
└── tailscale
```

---
## 🎯 Project Goals

The goal of this project is to build a homelab using **Proxmox** as the backbone, enabling you to run daily-use tools, experiment for work, or just have fun tinkering with new tech.

---
## 🧱 Tech Stack

| Icon | Technology | Purpose |
|------|-----------|---------|
| <img src="./docker/homepage/icons/proxmox.png" width="20" height="20"> | **[Proxmox](proxmox/README.md)** | Bare metal hypervisor & virtualization |
| <img src="./docker/homepage/icons/terraform_icon.png" width="20" height="20"> | **[Terraform](automation/terraform/README.md)** | Infrastructure-as-code provisioning |
| <img src="./docker/homepage/icons/ansible.png" width="20" height="20"> | **[Ansible](automation/ansible/README.md)** | Configuration management & automation |
| <img src="./docker/homepage/icons/docker.png" width="20" height="20"> | **[Docker](docker/README.md)** | Containerization & lightweight services |
| <img src="./docker/homepage/icons/kubernetes.png" width="20" height="20"> | **[Kubernetes](./kubernetes/README.md)** | Container orchestration & GitOps |
| <img src="./docker/homepage/icons/prometheus.png" width="20" height="20"> | **[Prometheus](observability/prometheus/README.md)** | Metrics collection & monitoring |
| <img src="./docker/homepage/icons/grafana.png" width="20" height="20"> | **[Grafana](observability/prometheus/README.md)**| Dashboards & visualization |
| <img src="./docker/homepage/icons/loki.png" width="20" height="20"> | **[Loki](observability/prometheus/README.md)** | Log aggregation & analysis |
| <img src="./docker/homepage/icons/tailscale.png" width="20" height="20"> | **[Tailscale](tailscale/README.md)** | Secure mesh VPN networking |

---
## 🖼️ Infrastructure Snapshots
![proxmox-oci](./pictures/proxmox_oci.png)
![homepage](./pictures/homepage.png)
![grafana](./pictures/grafana.png)

---
## 🤝 Contributing
Contributions are welcome!

1. Fork the repo  
2. Create a feature branch  
3. Commit your changes  
4. Push your branch  
5. Open a Pull Request  

If you want to share your own homelab ideas or improvements, I’d love to see them.

---
## 💬 Support & Feedback
Have questions, suggestions, or want to show your own setup?  
Open an issue — I’m happy to chat.

---
## 🧭 Roadmap
- Expand documentation for each module  
- Add diagrams for network, Kubernetes, and automation flows  
- Improve Terraform + Ansible integration  
- Add more observability components  
- Add CI/CD for homelab automation  

---
> _Made with ❤️ for homelab enthusiasts!_
