# Kubernetes

## Why Kubernetes
Kubernetes is a container orchestration system. I have a k8s cluster for learning purposes.

## Selfhosted
I use `argocd` + ``helm`` in order to deploy everything.
Here is the most important stuff you can find on my kubernetes cluster:

  - [ArgoCD](/kubernetes/argocd/clusters/addons/software-base/argocd): gitops
  - [Certmanager](/kubernetes/argocd/clusters/addons/software-base/certmanager): certificates
  - [External-dns](/kubernetes/argocd/clusters/addons/software-base/external-dns): dynamic dns updater
  - [External-secrets](/kubernetes/argocd/clusters/addons/software-base/external-secrets): secrets
  - [Traefik](/kubernetes/argocd/clusters/addons/software-base/traefik): ingress
  - [Longhorn](/kubernetes/argocd/clusters/addons/software-base/longhorn): distributed storage
  - [Prometheus](/kubernetes/argocd/clusters/addons/monitoring/prometheus): metrics solution, configured as remote writer
  - [Promtail](/kubernetes/argocd/clusters/addons/monitoring/promtail): logs solution
  - [Tailscale](/kubernetes/argocd/clusters/addons/software-base/tailscale): zero config vpn
  - [Velero](/kubernetes/argocd/clusters/addons/software-base/velero): backup solution

  ## Work In Progress