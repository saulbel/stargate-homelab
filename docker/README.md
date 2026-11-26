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

| Service | Host | IP | Ports |
|---|---|---|---|
| [adguard](./adguard) | LXC 111 | `192.168.1.225` (macvlan) | 53, 67-68, 80, 443, 853, 3000 |
| [amule](./amule) | LXC 122 | `192.168.1.22` | 4711 (web), 4712, 4662, 4665/udp, 4672/udp |
| [bookstack](./bookstack) | LXC 124 | `192.168.1.24` | 6875 |
| [caddy](./caddy) | LXC 120 | `192.168.1.20` | 80, 443 |
| [deluge](./deluge) | LXC 115 | `192.168.1.15` | 8112 (web), 6881 |
| [handbrake](./handbrake) | LXC 123 | `192.168.1.23` | 5800 |
| [homepage](./homepage) | LXC 110 | `192.168.1.10` | 3000 |
| [infisical](./infisical) | LXC 127 | `192.168.1.27` | 80 |
| [jackett](./jackett) | LXC 116 | `192.168.1.16` | 9117 |
| [kavita](./kavita) | LXC 112 | `192.168.1.12` | 5000 |
| [lookbusy](./lookbusy) | ubuntu-arm (OCI) | Tailscale | none |
| [minio](./minio) | LXC 125 | `192.168.1.25` | 9000 (API), 9001 (console) |
| [playground](./playground) | LXC 121 | `192.168.1.21` | 5432 |
| [plex](./plex) | LXC 114 | `192.168.1.14` | 32400 (host network) |
| [prometheus-loki](./prometheus-loki) | ubuntu-arm (OCI) | Tailscale | 9090, 3000, 3100, 9100 |
| [radarr](./radarr) | LXC 117 | `192.168.1.17` | 7878 |
| [rancher](./rancher) | LXC 128 | `192.168.1.28` | 80, 443 |
| [sonarr](./sonarr) | LXC 118 | `192.168.1.18` | 8989 |
| [tautulli](./tautulli) | LXC 119 | `192.168.1.19` | 8181 |
| [vaultwarden](./vaultwarden) | LXC 113 | `192.168.1.13` | 80 |
| [watchtower](./watchtower) | each host | - | none |

Caddy proxies each `https://<service>.home` name to these IPs.

---

## To Improve

- Add healthchecks (only infisical and playground have one)
