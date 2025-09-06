# 🖥️ Proxmox

Proxmox is a **Type 1 hypervisor** based on KVM—essentially _Debian + KVM + GUI_.  
It's my homelab choice because it's pure Linux under the hood and doesn't require special hardware like ESXi.

---

## 🛠️ Hardware Overview

This is the hardware used for hosting Proxmox:

![proxmox-hw](https://github.com/user-attachments/assets/52d64f7f-adcc-47c4-8ab5-a477c270549c)

**Storage distribution:**
- **NVME 2242 256GB:** `Proxmox OS`, `VM ISOs`, and `Container templates`
- **NVME 2280 1TB:** `VMs and CTs storage`
- **HDD 2.5 2TB:** `Media`

---

## 🏠 Self-Hosted Services

Currently hosted on my NUC:

![proxmox-only](https://github.com/user-attachments/assets/cb60ca76-07f9-4811-a177-aca02df8119f)

### VMs (K3s cluster)
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

### LXCs
- [Adguard](/docker/adguard): Adblock + DNS server
- [Amule](/docker/amule): P2P downloads
- [Bookstack](/docker/bookstack): Wiki
- [Caddy](/docker/caddy): Reverse proxy
- [Deluge](/docker/deluge): Torrent downloads
- [Handbrake](/docker/handbrake): Transcoder
- [Homepage](/docker/homepage): Dashboard
- [Infisical](/docker/infisical): Secrets management
- [Jackett](/docker/jackett): Trackers
- [Kavita](/docker/kavita): Library
- [Minio](/docker/minio): S3 storage
- [Plex](/docker/plex): Media player
- [Radarr](/docker/radarr): Movie manager
- [Sonarr](/docker/sonarr): TV show manager
- [Tautulli](/docker/tautulli): Plex stats
- [Vaultwarden](/docker/vaultwarden): Password vault

---

## ➕ Proxmox Addons

While I don't recommend heavy customization of the Proxmox host, I do use a couple of helpful addons:
- **Tailscale:** Remote access from anywhere
- **PVE exporter:** Scrape metrics and store them securely (Tailscale is essential for this)

---

## 📊 Proxmox Metrics

I use [PVE exporter](/observability/prometheus/README.md) to expose all metrics from Proxmox VMs and LXCs.

---

## 🧩 Proxmox Template Creation

`Cloud-init` customizes Linux VMs at boot—perfect for spinning up minimal images with Terraform.

**Steps to create a Proxmox cloud-init template:**
```sh
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
virt-customize -a debian-12-genericcloud-amd64.qcow2 --install qemu-guest-agent --run-command 'systemctl start qemu-guest-agent.service && systemctl enable qemu-guest-agent.service'
virt-customize -a debian-12-genericcloud-amd64.qcow2 --truncate /etc/machine-id
qm create 200 --memory 2048 --name debian-cloud --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm importdisk 200 debian-12-genericcloud-amd64.qcow2 local-lvm
qm set 200 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-200-disk-0   
qm set 200 --ide2 local-lvm:cloudinit
qm set 200 --boot order=scsi0
qm set 200 --serial0 socket --vga serial0
qm set 200 --agent enabled=1
qm template 200
```

---

> _Virtualize your homelab, one VM or container at a time!_