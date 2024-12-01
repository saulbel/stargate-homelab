# Proxmox
![proxmox-1](https://github.com/user-attachments/assets/cea61399-5e2a-4172-954b-8d7f728e0596)

## Why Proxmox
Proxmox is an Hypervisor Type 1 based on `KVM`. It is just Debian + KVM + UI. I prefer it for a homelab because it is pure `Linux` under the hood, plus you do not need specific hardware unlike `ESXi`.

This is the hardware used for hosting proxmox :
![proxmox-hw](https://github.com/user-attachments/assets/52d64f7f-adcc-47c4-8ab5-a477c270549c)

The storage distribution is the following:

- NVME 2242 256GB : ``Proxmox OS``, ``VM ISOs`` and ``Container templates``
- NVME 2280 1TB: ``VMs and CTs storage``
- HDD 2.5 2TB: ``Media``

 ## Selfhosted
 Right now I have the following stuff hosted on my `NUC`:
![proxmox-only](https://github.com/user-attachments/assets/69344b26-58cf-436a-bf06-be1c5d5f8f80)
- 3 VMS (K3s cluster):
  - ``ArgoCD``: gitops
  - ``Certmanager``: certificates
  - ``Metallb``: loadbalancer
  - ``Traefik``: ingress
  - ``Longhorn``: distributed storage
- 15 LXC containers:
  - ``adguard``: adblock + dns server
  - ``amule``: p2p downloads
  - ``bookstack``: wiki
  - ``deluge``: torrent downloads
  - ``handbrake``: transcoder
  - ``jackett``: trackers
  - ``kavita``: library
  - ``homepage``: dashboard solution
  - ``npm``: reverse proxy
  - ``plex``: media player
  - ``radarr``: movie collection manager
  - ``sonarr``: tv show collection manager
  - ``tautulli``: stats for plex and user management
  - ``tools``: packer + network utilities
  - ``vaultwarden``: password vault

 ## Proxmox Addons
I do not recommend messing up with proxmox host but you might wanna add some stuff to it. In my case I have a couple of things installed:

- ``Tailscale``: to be able to access proxmox from anywhere
- ``PVE exporter``: to be able to scrape metrics and store them in an OCI server (yes, tailscale is pretty much needed for this)

 ## Proxmox Metrics
The idea is to be able to gather metrics about CPU, RAM, disk and network resources of proxmox guests (vms or lxc) via prometheus

- Create proxmox `API user`
```
pveum user add pve-exporter@pve -password <password>
# add role PVEAuditor
pveum acl modify / -user pve-exporter@pve -role PVEAuditor
```
- Create `Linux user`
```
useradd -s /bin/false pve-exporter
```
- Create `venv`
```
# install python3-venv
apt update
apt install -y python3-venv
# create venv
python3 -m venv /opt/prometheus-pve-exporter
```
- Install `prometheus proxmox ve exporter`
```
# active venv
source /opt/prometheus-pve-exporter/bin/activate
# install prometheus-pve-exporter
pip install prometheus-pve-exporter
# to leave venv
deactivate
```
- Create `systemd-service`
```
# add this to /etc/systemd/system/prometheus-pve-exporter.service
[Unit]
Description=Prometheus Proxmox VE Exporter
Documentation=https://github.com/prometheus-pve/prometheus-pve-exporter

[Service]
Restart=always
User=pve-exporter
ExecStart=/opt/prometheus-pve-exporter/bin/pve_exporter --config.file /etc/prometheus/pve.yml

[Install]
WantedBy=multi-user.target

# reload systemd, enable and start service
systemctl daemon-reload
systemctl enable prometheus-pve-exporter.service
systemctl start prometheus-pve-exporter.service

# verify pve_exporter is listening to TCP 9221
ss -lntp | grep 9221
tcp        0      0 0.0.0.0:9221            0.0.0.0:*               LISTEN      915/python3
```
- Test funcionality
```
curl --silent http://127.0.0.1:9221/pve | grep pve_version_info
http://192.168.1.127:9221/pve?target=192.168.1.127&cluster=1&node=1
```
- Add to `prometheus.yml` config
```
- job_name: 'pve-exporter'
static_configs:
    - targets:
                # I have tailscale ip here instead of localhost
    - 127.0.0.1:9221
metrics_path: /pve
params:
    module: [default]
```
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


