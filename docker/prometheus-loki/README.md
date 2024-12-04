# prometheus-loki
```
stargate-docker
└── config
    └── alertmanager.yml
    └── prometheus.yml
    └── promtail-config.yml
    └── rules.yml
└── grafana-dashboards
    └── loki-k3s.json
    └── prometheus-k3s.json
    └── proxmox.json
    └── win-exporter.json
└── docker-compose.yaml
```
## Notes
- I have a big ``docker-compose`` for ``grafana``, ``prometheus`` and ``loki``.
- Remember to put your ``target ips`` in ``prometheus.yml``. I did not use env variables because prometheus config does not support them.