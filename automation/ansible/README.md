# Ansible

## Why Ansible
Ansible is another automation tool that is mostly used for configure, deploy and update software. 

## Selfhosted
Here is all my ``ansible`` playbooks so you can use them.
```
stargate-ansible
└── install-and-configure-firewalld.yaml
└── install-and-configure-ufw.yaml
└── install-docker-debian.yaml
└── install-docker-ubuntu.yaml  
└── install-tools.yaml 
└── reboot-host.yaml 
```

## K3S
If you wanna set up a self hosted ha kubernetes cluster I recommend you to take a look at this [repo](https://github.com/techno-tim/k3s-ansible). It's the one that I use in my `terraform` config in order to set up a k3s cluster.

## Semaphore or AWX/Tower
You can use one of these in order to centralize all your ansible playbooks management. I have toy around with them but right now I don't have a use case for them.

## To improve
- Add more playbooks.