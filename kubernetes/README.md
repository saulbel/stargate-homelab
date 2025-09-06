# ☸️ Kubernetes 

Kubernetes is a powerful container orchestration system.  
I run a k8s cluster in my homelab for learning, experimentation, and self-hosting modern cloud-native apps.

---

## 🚀 Why Kubernetes?

- **Scalability:** Easily scale apps up or down.
- **Self-healing:** Automatically restarts failed containers.
- **Declarative:** Manage infrastructure and apps with YAML manifests.
- **Ecosystem:** Huge community and tons of integrations.

---

## 🪶 Why K3s?

I use **K3s** for my homelab Kubernetes cluster because it's lightweight, simple to install, and ideal for resource-constrained environments.  
I rely on [techno-tim/k3s-ansible](https://github.com/techno-tim/k3s-ansible) + **Terraform** for automated provisioning.

---

## 📦 Self-Hosted Apps

I use [ArgoCD](./argocd/README.md) to deploy and manage everything in my cluster.  
Here are the most important components running on my Kubernetes cluster:

- [ArgoCD](/kubernetes/argocd/clusters/addons/software-base/argocd): GitOps for automated deployments
- [Certmanager](/kubernetes/argocd/clusters/addons/software-base/cert-manager): Automated certificate management
- [External-dns](/kubernetes/argocd/clusters/addons/software-base/external-dns): Dynamic DNS updater
- [External-secrets](/kubernetes/argocd/clusters/addons/software-base/external-secrets): Secure secrets management
- [Longhorn](/kubernetes/argocd/clusters/addons/software-base/longhorn): Distributed storage solution
- [Prometheus](/kubernetes/argocd/clusters/addons/monitoring/prometheus): Metrics and monitoring (remote writer)
- [Promtail](/kubernetes/argocd/clusters/addons/monitoring/promtail): Centralized logging
- [Tailscale](/kubernetes/argocd/clusters/addons/software-base/tailscale): Zero-config VPN for secure networking
- [Traefik](/kubernetes/argocd/clusters/addons/software-base/traefik): Ingress controller for routing traffic
- [Velero](/kubernetes/argocd/clusters/addons/software-base/velero): Backup and restore solution

---

## 🛠️ To Improve

- Automate cluster upgrades and maintenance

---

> _Orchestrate your homelab, one pod at a time!_