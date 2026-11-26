# prometheus-loki
```
prometheus-loki
└── config
    └── prometheus.yml
    └── promtail-config.yaml
└── grafana-dashboards
    └── loki-k3s.json
    └── prometheus-k3s.json
    └── proxmox.json
    └── rancher-audit.json
└── docker-compose.yaml
```
## Notes
- It runs on ``ubuntu-arm`` (an OCI ARM VM, not a Proxmox LXC) in ``/home/ubuntu/monitoring``. ``lookbusy`` runs on the same VM. The K3s Prometheus remote-writes here and Promtail pushes logs here through Tailscale.
- I have a big ``docker-compose`` for ``grafana``, ``prometheus`` and ``loki``.
- Remember to put your ``target ips`` in ``prometheus.yml``. I did not use env variables because prometheus config does not support them.
- The ports ``9090``, ``3000``, ``3100`` and ``9100`` listen on all interfaces. Only the OCI firewall protects them, so keep them closed there.
