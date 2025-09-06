# 🐳 Docker

Docker is the industry-standard way to build, run, and manage containers.  
While Proxmox offers LXC containers, I run Docker inside LXC for maximum compatibility and flexibility. Docker is widely used and knowing its ins and outs is essential for modern self-hosting.

---

## 🚀 Why Docker?

- **Portability:** Run your apps anywhere, from laptops to servers.
- **Isolation:** Each service runs in its own container.
- **Community:** Thousands of ready-to-use images.
- **DevOps-friendly:** Integrates with CI/CD and orchestration tools.

---

## 📦 Self-Hosted Services

This folder contains all my `docker-compose` files and configurations for self-hosted services.  
Feel free to use them for your own setup—or as a backup reference!

```
docker
└── adguard
└── amule
└── bookstack
└── deluge
└── handbrake
└── homepage
└── jackett
└── kavita
└── lookbusy
└── minio
└── nginx
└── plex
└── prometheus-loki
└── pzserver
└── radarr
└── sonarr
└── tautulli
└── teamspeak
└── vaultwarden
```

Each subfolder contains a `docker-compose.yaml` and any necessary configuration files.

---

## 🛠️ To Improve

- Add usage instructions and environment variable examples for each service
- Organize configs for easier updates and backups
- Add healthcheck and monitoring examples

---

> _Containerize your homelab, one container at a time!_