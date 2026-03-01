# Changelog

All notable changes to this project will be documented in this file.

## [1.7.0] - Terraform Security & Organization
- Terraform: Split monolithic `main.tf` into separate files (`lxc.tf`, `vms.tf`, `k3s-setup.tf`)
- Terraform: Added `sensitive = true` to password and auth key variables

## [1.6.0] - Istio Migration
- Migrated from Traefik to Istio service mesh
- Added Istio Base (CRDs), Istiod control plane, Istio Ingress Gateway
- Added Kiali for service mesh observability
- All services now use VirtualServices instead of IngressRoutes
- Added sidecar injection for Vaultwarden with AuthorizationPolicy
- External-DNS now supports `istio-virtualservice` source

## [1.5.0] - System Upgrade Controller
- Replaced Kured with System Upgrade Controller for K3s upgrades
- Added RBAC permissions for default ServiceAccount patching

## [1.4.0] - Terraform Cleanup
- Terraform restructuring and cleanup
- K3s: Wait for cloud-init before Tailscale installation
- Various LXC disk and RAM adjustments

## [1.3.0] - Kured
- Added Kured for Kubernetes node reboot management

## [1.2.0] - K3s Expansion
- Updated K3s VM templates and configurations
- Prometheus dashboard improvements

## [1.1.0] - ArgoCD GitOps
- Added ArgoCD for GitOps deployments
- Bootstrap apps structure with multi-source pattern
- ArgoCD Applications: Cert-manager, External-DNS, External-secrets, Longhorn, NFS CSI, Prometheus, Promtail, Traefik

## [1.0.0] - K3s Cluster
- Initial K3s cluster deployment (3 nodes: 1 master + 2 workers)
- MetalLB for LoadBalancer services
- Longhorn for distributed storage
- NFS CSI driver

## [0.9.0] - Terraform Infrastructure
- Terraform provisioning for Proxmox (21 LXCs + 3 VMs)
- Automated Ansible integration for post-provisioning

## [0.8.0] - Ansible Automation
- Ansible playbooks for Docker, UFW/Firewalld, tools, reboots
- PBS, Rancher, Infisical LXCs
- Various LXC configurations (Plex, *arr stack, Vaultwarden, Bookstack, MinIO)

## [0.7.0] - Docker Services
- Homepage dashboard with custom icons
- Prometheus + Loki + Grafana observability stack
- Docker services: AdGuard, Watchtower, Plex (HW transcoding), Handbrake, Vaultwarden, *arr stack, Caddy

## [0.6.0] - Observability & Tailscale
- Prometheus, Loki, Grafana dashboards (Proxmox, K3s, Windows Exporter)
- Tailscale VPN mesh network (LXC + K3s integration)

## [0.5.0] - Proxmox Platform
- Proxmox VE documentation (Intel NUC hardware, network, storage, templates)

## [0.4.0] - Documentation
- Comprehensive README files
- Network topology and service inventory

## [0.3.0] - Repository Structure
- Repository organization
- Initial Docker service configurations

## [0.2.0] - Proxmox Setup
- Proxmox initial setup documentation
- Basic LXC container templates

## [0.1.0] - Initial Commit
- Repository creation
- Basic structure