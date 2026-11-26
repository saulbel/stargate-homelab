# Kubernetes

Kubernetes is a powerful container orchestration system.  
I run a k8s cluster in my homelab for learning, experimentation, and self-hosting modern cloud-native apps.

---

## Why Kubernetes?

Honestly, mostly to learn it hands-on. I don't need Kubernetes for a homelab this size, but running a real cluster — with GitOps, ingress, cert management, backups — is the best way I've found to actually understand the pieces instead of just reading about them.

---

## Why K3s?

I use **K3s** for my homelab Kubernetes cluster because it's lightweight, simple to install, and ideal for resource-constrained environments.  
Clusters are provisioned by **Rancher** (running in an LXC) with the [Proxmox node driver](https://github.com/Lore09/pve-rancher-driver): Rancher clones a cloud-init template, creates the VMs, installs K3s and handles upgrades and node replacement.  
Each cluster is a `provisioning.cattle.io/v1 Cluster` in `fleet-default` with one `PveConfig` per node pool (`masters`, `workers`), so the whole cluster is declared as YAML.

- **Template:** VMID `200` (`debian-13`, in the `rancher-managed` pool), see [Proxmox](/proxmox/README.md#proxmox-template-creation).
- **VMIDs / IPs per role:** masters `210-219` → `192.168.1.50-59`, workers `220-239` → `192.168.1.60-79` (IP = start + VMID offset). `192.168.1.80-100` is reserved for MetalLB.
- **K3s flags:** `machineGlobalConfig.disable: [servicelb, traefik, local-storage]`. MetalLB and Istio replace `servicelb` and `traefik`. CNI is the K3s default (flannel).
- **SSH:** `sshkeys` in the `PveConfig` is not in git on purpose. The live value is kept (server-side apply does not remove it). For a new cluster, add `sshkeys` to the Rancher object by hand or put the key in the `cicustom` snippet.

---

## Self-Hosted Apps

I use [ArgoCD](./argocd/README.md) to deploy and manage everything in my cluster.  
Here are the most important components running on my Kubernetes cluster:

- [ArgoCD](/kubernetes/argocd/clusters/addons/software-base/argocd): GitOps for automated deployments
- [Certmanager](/kubernetes/argocd/clusters/addons/software-base/cert-manager): Installed, no issuer configured yet
- [External-dns](/kubernetes/argocd/clusters/addons/software-base/external-dns): Dynamic DNS updater
- [External-secrets](/kubernetes/argocd/clusters/addons/software-base/external-secrets): Secure secrets management
- [MetalLB](/kubernetes/argocd/clusters/addons/software-base/metallb): Layer 2 LoadBalancer (pool `192.168.1.80-100`)
- [Istio Base](/kubernetes/argocd/clusters/addons/software-base/istio-base): Istio CRDs
- [Istiod](/kubernetes/argocd/clusters/addons/software-base/istiod): Istio control plane
- [Istio Ingress Gateway](/kubernetes/argocd/clusters/addons/software-base/istio-ingressgateway): Istio ingress proxy (LoadBalancer)
- [Kiali](/kubernetes/argocd/clusters/addons/monitoring/kiali): Service mesh observability dashboard
- [NFS](/kubernetes/argocd/clusters/addons/software-base/nfs): CSI driver
- [Prometheus](/kubernetes/argocd/clusters/addons/monitoring/prometheus): Metrics and monitoring (remote writer)
- [Promtail](/kubernetes/argocd/clusters/addons/monitoring/promtail): Centralized logging
- [Tailscale](/kubernetes/argocd/clusters/addons/software-base/tailscale): Zero-config VPN for secure networking
- [Vaultwarden](/kubernetes/argocd/clusters/addons/apps/vaultwarden): Password manager (HTTP only for now)
- [Uptime Kuma](/kubernetes/argocd/clusters/addons/apps/uptime-kuma): Uptime monitoring
- [Velero](/kubernetes/argocd/clusters/addons/software-base/velero): Backup and restore solution

---

## To Improve

- Configure a cert-manager issuer
- Serve Vaultwarden over HTTPS