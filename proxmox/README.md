# Proxmox

## Why Proxmox
Proxmox is a `Type 1 hypervisor` based on `KVM`. It is just `Debian + KVM + GUI`. I prefer it for a homelab because it is pure `Linux` under the hood, plus you do not need specific hardware unlike `ESXi`.

This is the hardware used for hosting proxmox :
![proxmox-hw](https://github.com/user-attachments/assets/52d64f7f-adcc-47c4-8ab5-a477c270549c)

The storage distribution is the following:

- NVME 2242 256GB : ``Proxmox OS``, ``VM ISOs`` and ``Container templates``
- NVME 2280 1TB: ``VMs and CTs storage``
- HDD 2.5 2TB: ``Media``

## Selfhosted
Right now I have the following stuff hosted on my `NUC`:
![proxmox-only](https://github.com/user-attachments/assets/cb60ca76-07f9-4811-a177-aca02df8119f)
- ``VMS`` (K3s cluster):
  - ``ArgoCD``: gitops
  - ``Certmanager``: certificates
  - ``External-dns``: dynamic dns updater
  - ``External Secrets Operator``: secrets
  - ``Traefik``: ingress
  - ``Longhorn``: distributed storage
  - ``Prometheus``: metrics solution, configured as remote writer
  - ``Promtail``: logs solution
  - ``Tailscale``: zero config vpn
  - ``Velero``: backup solution
- ``LXC``:
  - [Adguard](/docker/adguard): adblock + dns server
  - [Amule](/docker/amule): p2p downloads
  - [Bookstack](/docker/bookstack): wiki
  - [Deluge](/docker/deluge): torrent downloads
  - [Handbrake](/docker/handbrake): transcoder
  - [Jackett](/docker/jackett): trackers
  - [Kavita](/docker/kavita): library
  - [Homepage](/docker/homepage): dashboard
  - [Minio](/docker/minio): s3 
  - [Npm](/docker/nginx): reverse proxy
  - [Plex](/docker/plex): media player
  - [Radarr](/docker/radarr): movie collection manager
  - [Sonarr](/docker/sonarr): tv show collection manager
  - [Tautulli](/docker/tautulli): stats for plex
  - [Vaultwarden](/docker/vaultwarden): password vault

## Proxmox Addons
I do not recommend messing up with proxmox host but you might wanna add some stuff to it. In my case I have a couple of things installed:

- ``Tailscale``: to be able to access proxmox from anywhere
- ``PVE exporter``: to be able to scrape metrics and store them in an OCI server (yes, tailscale is pretty much needed for this)

## Proxmox Metrics
I use [PVE exporter](/observability/prometheus/README.md) in order to expose all the metrics from proxmox vms/lxcs.

## Proxmox Template
``Cloud-init`` is a service used for customizing Linux-based operating systems in the cloud. It allows you to customize virtual machines provided by a cloud vendor by modifying the generic OS configuration on boot.
 
The idea is to have a minimal image and use it to spin up VMs with `Terraform`. So these are the steps to achieve it:
```
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
