# Prometheus

## Why Prometheus
Prometheus is a ``TSDB`` that is used to store metrics. It works just the other way around ``InfluxDB`` does, I mean, It does not expect data, it ``scrapes`` it.

## Prometheus Setup
I use [PVE exporter](/proxmox/README.md#L48) in order to expose all the metrics from proxmox vms/lxcs and I have installed node-exporter in docker containers among all k3s nodes and OCI VMs. Why dont we install ``node-exporter`` in lxcs you may wonder? Because the metrics are wrong, it exposes host’s metrics instead of lxc’s.

``Tailscale`` is used in order to prometheus to be able to scrape from my proxmox without exposing anything to internet.

 ## Prometheus config
 To be added

 ## Grafana dashboard
 To be added