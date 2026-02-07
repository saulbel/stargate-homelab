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
| Layer | Tools |
|------|-------|
| **Virtualization** | **[Proxmox](proxmox/README.md)** |
| **Provisioning** | **[Terraform](automation/terraform/README.md)** |
| **Configuration Management** | **[Ansible](automation/ansible/README.md)** |
| **Containers** | **[Docker](docker/README.md)** |
| **Orchestration** | **[Kubernetes](./kubernetes/README.md)** + **[ArgoCD](kubernetes/argocd/README.md)** (GitOps) |
| **Observability** | **[Prometheus](observability/prometheus/README.md)**, Grafana, Loki |
| **Networking** | **[Tailscale](tailscale/README.md)** |

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
