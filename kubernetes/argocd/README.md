# 🚦 ArgoCD

ArgoCD is a declarative GitOps continuous delivery tool for Kubernetes.  
It keeps your cluster state in sync with your Git repositories, automating deployments and lifecycle management.

---

## 🚀 Why ArgoCD?

- **GitOps:** Manage your Kubernetes apps using Git as the source of truth.
- **Declarative:** Define desired state with YAML manifests or Helm charts.
- **Automated sync:** Automatically applies changes from your repo to your cluster.
- **Visual dashboard:** Web UI for monitoring and managing deployments.
- **Rollback:** Easily revert to previous versions.

---

## 📁 Project Structure

```
argocd
└── clusters
    └── addons
        └── apps
        └── jobs
        └── monitoring
        └── software-base
    └── bootstrap
        └── apps.yaml
        └── jobs.yaml
        └── kustomization.yaml
        └── monitoring.yaml
        └── software-base.yaml
    └── components
        └── apps
        └── jobs
        └── monitoring
        └── software-base
```
---

## 🚦 App of Apps Pattern

ArgoCD supports the **App of Apps** pattern, which allows you to manage multiple applications through a single parent application.  
This parent app (often called "bootstrap") references other ArgoCD Application manifests, enabling you to declaratively bootstrap your entire cluster from one place.

**Benefits:**
- Centralized management of all apps
- Easy onboarding and scaling of new services
- Consistent GitOps workflows

In this repo, the `bootstrap.yaml` file is the parent app that syncs all core and addon applications.

---

## 🛠️ Getting Started

After K3s is set up, the following script is executed by Terraform to install ArgoCD and bootstrap your apps:

```bash
#!/bin/bash

set -e

echo "🚀 Ensuring external-secrets namespace exists..."
if ! kubectl get namespace external-secrets >/dev/null 2>&1; then
  kubectl create namespace external-secrets
  echo "✅ Created external-secrets namespace."
else
  echo "ℹ️ external-secrets namespace already exists. Skipping creation."
fi

echo "🔐 Applying Infisical credentials secret..."
kubectl apply -f /home/saul/k3s/infisical/secret.yaml

echo "🚀 Installing ArgoCD..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values /home/saul/k3s/argocd/config.yaml

echo "🔐 Adding Git SSH secret..."
kubectl apply -f /home/saul/k3s/argocd/argocd-repo-secret.yaml

echo "📦 Bootstrapping ArgoCD apps..."
kubectl apply -f /home/saul/k3s/argocd/bootstrap.yaml
```

This script is called in `main.tf` after K3s setup:

```hcl
# install argocd and apps
provisioner "local-exec" {
    working_dir = "/home/saul/k3s"
    command = "./install.sh"
}
```

---

## 📦 Managed Apps

ArgoCD manages all core and addon apps in the cluster, including:
- [GitOps](/kubernetes/argocd/clusters/addons/software-base/argocd) (ArgoCD itself)
- [Certificate management](/kubernetes/argocd/clusters/addons/software-base/cert-manager) (Certmanager)
- [DNS automation](/kubernetes/argocd/clusters/addons/software-base/external-dns) (External-dns)
- [Secrets management](/kubernetes/argocd/clusters/addons/software-base/external-secrets) (External-secrets)
- [Storage](/kubernetes/argocd/clusters/addons/software-base/longhorn) (Longhorn)
- [Ingress](/kubernetes/argocd/clusters/addons/software-base/traefik) (Traefik)
- [VPN](/kubernetes/argocd/clusters/addons/software-base/tailscale) (Tailscale)
- [Metrics](/kubernetes/argocd/clusters/addons/monitoring/prometheus) (Prometheus)
- [Logs](/kubernetes/argocd/clusters/addons/monitoring/promtail) (Loki)
- [Backup](/kubernetes/argocd/clusters/addons/software-base/velero) (Velero)

---

## 🛠️ To Improve

- Add more example applications and Helm charts
- Document best practices for GitOps workflows
- Integrate notifications and automated rollbacks

---

> _Automate your Kubernetes deployments, one commit at a time!_