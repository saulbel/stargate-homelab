# Terraform

## Why Terraform
Terraform is an Infra as a Code (``IaC``) tool that allows us to provision and manage our infra. It has multiple providers, in our case we are gonna use the following `proxmox` [one](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

## Selfhosted
Here is all my ``terraform`` files so you can use them.
```
stargate-terraform
└── main.tf
└── provider.tf
└── variables.tf
```

## Tfstate
Remember to save and secure your ``.tfstate``. You can use a ``s3 bucket`` in ``minio`` in order to do so.

## To improve
- Add a way to retrieve the different ``docker-compose.yaml`` files and start the containers automatically. 
- Find a way to connect to avoid the use of ``local-exec`` and ``remote-exec``.