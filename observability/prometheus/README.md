# Prometheus

## Why Prometheus
Prometheus is a ``TSDB`` that is used to store metrics. It works just the other way around ``InfluxDB`` does, I mean, It does not expect data, it ``scrapes`` it.

## Prometheus Setup
I use ``PVE exporter`` in order to expose all the metrics from proxmox vms/lxcs. Why don't we install node-exporter in lxcs you may wonder? Because the metrics are wrong, it exposes host’s metrics instead of lxc’s.

``Tailscale`` is used in order to prometheus to be able to scrape from my proxmox without exposing anything to internet.

![prometheus](https://github.com/user-attachments/assets/16d2d0ee-8641-4217-b74a-1a740161496b)

## PVE Exporter Setup
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
      - 127.0.0.1:9221 # I have tailscale ip here instead of localhost
  metrics_path: /pve
  params:
```   

## Grafana dashboards
You can import my grafana dashboards from [here](/docker/prometheus-loki/grafana-dashboards/).
There are 4 dashboards, just in case you may wonder what they are for:
  
  - ``proxmox.json``: This is the one that shows everything the ``pve-exporter`` scrapes from. 
  - ``win-exporter.json``: It's a dashboard for a ``windows-exporter`` that I use on my own pc.
  - ``loki-k3s.json``: It`s a kubernetes ``loki`` dashboard.
  - ``prometheus-k3s.json``: It`s a kubernets ``prometheus`` dashboard.

## To improve
- Configure ``alertmanager`` and send those alerts to a ``telegram channel``
- Study whether to add ``promtail`` to proxmox node or to each lxc individually