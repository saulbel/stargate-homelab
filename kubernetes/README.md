# Kubernetes

## Why Kubernetes
Kubernetes is a container orchestration system. I have a k8s cluster for learning purposes.

## Selfhosted
I use `argocd` + ``helm`` in order to deploy everything.
Here is all you can find on my kubernetes cluster:

  - ``ArgoCD``: gitops
  - ``Certmanager``: certificates
  - ``External-dns``: dynamic dns updater
  - ``External Secrets Operator``: secrets
  - ``Traefik``: ingress
  - ``Longhorn``: distributed storage
  - ``Prometheus``: metrics solution, configured as remote writer
  - ``Promtail``: logs solution
  - ``Tailscale``: zero config vpn
  - ``Velero``: backup solution