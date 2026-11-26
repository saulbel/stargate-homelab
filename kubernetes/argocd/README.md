# ArgoCD

ArgoCD is a declarative GitOps continuous delivery tool for Kubernetes.  
It keeps your cluster state in sync with your Git repositories, automating deployments and lifecycle management.

---

## Why ArgoCD?

This repo is the source of truth for my cluster — I commit a manifest and ArgoCD applies it, no `kubectl apply` from my laptop. If something breaks, reverting the commit reverts the cluster, which has saved me more than once.

---

## Project Structure

```
argocd
└── clusters
    └── addons
        └── apps
        └── monitoring
        └── software-base
    └── bootstrap
        └── apps.yaml
        └── clusters.yaml
        └── kustomization.yaml
        └── monitoring.yaml
        └── software-base.yaml
    └── components
        └── apps
        └── clusters
        └── monitoring
        └── software-base
└── values.yaml
```
---

## App of Apps Pattern

The root Application `bootstrap` points to [bootstrap](/kubernetes/argocd/clusters/bootstrap). That folder holds one Application for each category (`software-base`, `monitoring`, `apps`, `clusters`), and each one points to its folder in `components/`.

The root Application is not in this repo. The script below applies it from `/home/saul/k3s/argocd/bootstrap.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bootstrap
  namespace: argocd
spec:
  project: default
  source:
    repoURL: git@github.com:saulbel/stargate-homelab.git
    targetRevision: main
    path: kubernetes/argocd/clusters/bootstrap
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

---

## Getting Started

Once Rancher has provisioned the cluster, I run the following script by hand against it (kubeconfig from Rancher) to install ArgoCD and bootstrap the apps:

```bash
#!/bin/bash

set -e

echo "Ensuring external-secrets namespace exists..."
if ! kubectl get namespace external-secrets >/dev/null 2>&1; then
  kubectl create namespace external-secrets
  echo "Created external-secrets namespace."
else
  echo "external-secrets namespace already exists. Skipping creation."
fi

echo "Applying Infisical credentials secret..."
kubectl apply -f /home/saul/k3s/infisical/secret.yaml

echo "Installing ArgoCD..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values kubernetes/argocd/values.yaml

echo "Adding Git SSH secret..."
kubectl apply -f /home/saul/k3s/argocd/argocd-repo-secret.yaml

echo "Bootstrapping ArgoCD apps..."
kubectl apply -f /home/saul/k3s/argocd/bootstrap.yaml
```
---

## To Improve

- Add ArgoCD notifications (for example, to the Telegram channel that Watchtower uses)
