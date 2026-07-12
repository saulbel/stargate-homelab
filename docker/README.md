# Docker

Docker is the industry-standard way to build, run, and manage containers.  
While Proxmox offers LXC containers, I run Docker inside LXC for maximum compatibility and flexibility. Docker is widely used and knowing its ins and outs is essential for modern self-hosting.

---

## Why Docker?

Proxmox already gives me LXCs, but I run Docker Compose inside each one anyway — it's how most self-hosted projects ship, so I get to use the image and compose file the maintainer actually tests instead of reverse-engineering a native install.

---

## Self-Hosted Services

This folder contains all my `docker-compose` files and configurations for self-hosted services.  
Feel free to use them for your own setup or as a backup reference!

```
docker
└── adguard
└── amule
└── bookstack
└── deluge
└── handbrake
└── homepage
└── infisical
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

---

## To Improve

- Add usage instructions and environment variable examples for each service
- Organize configs for easier updates and backups
- Add healthcheck and monitoring examples