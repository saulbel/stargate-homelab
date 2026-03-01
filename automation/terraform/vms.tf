#######
# VMS #
#######
#############################################################
# ubuntu 22 master --> k3s (using template)                 #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s-master" {
    name        = "k3s-master"
    description = "k3s master"
    node_name = "pve1"
    vm_id     = 210
    on_boot = false
    started = true

    agent {
        enabled = true
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.50/24"
                gateway = "192.168.1.127"
        }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225", "192.168.1.1"]
        }
        user_account {
          username = "ubuntu"
          keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }

    }

    network_device {
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        interface    = "scsi0"
        file_format = "raw"
        size = 20
        path_in_datastore = "vm-210-disk-0" 
    }

    cpu {
        architecture = "x86_64"
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 4096
    }

    vga {
        type = "serial0"
    }

    clone {
        vm_id = 201
        full = true
    }

    # skip pending kernel upgrade 
    provisioner "remote-exec" {
        inline = [
        "echo '$nrconf{restart} = 'a';' | sudo tee -a /etc/needrestart/conf.d/no-prompt.conf"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.50"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install tailscale
    provisioner "remote-exec" {
        inline = [
        "echo 'Waiting for cloud-init to finish...'",
        "cloud-init status --wait",
        "sudo apt update",
        "sudo apt upgrade -y",
        "sudo curl -fsSL https://tailscale.com/install.sh | sh",
        "sleep 20",
        "sudo tailscale up --authkey ${var.tailscale_auth_key}"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.50"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.50'"
    } 

    # # install docker
    # provisioner "local-exec" {
    #     working_dir = "/home/saul/ansible/"
    #     command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.50,"
    # }

}

#############################################################
# ubuntu 22 worker node 1 --> k3s (using template)          #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s-worker-1" {
    name        = "k3s-worker-1"
    description = "k3s worker 1"
    node_name = "pve1"
    vm_id     = 211
    on_boot = false
    started = true

    agent {
        enabled = true
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.51/24"
                gateway = "192.168.1.127"
        }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225", "192.168.1.1"]
        }
        user_account {
          username = "ubuntu"
          keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }

    }

    network_device {
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        interface    = "scsi0"
        file_format = "raw"
        size = 20
        path_in_datastore = "vm-211-disk-0" 
    }

    cpu {
        architecture = "x86_64"
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 4096
    }

    vga {
        type = "serial0"
    }

    clone {
        vm_id = 201
        full = true
    }

    # skip pending kernel upgrade 
    provisioner "remote-exec" {
        inline = [
        "echo '$nrconf{restart} = 'a';' | sudo tee -a /etc/needrestart/conf.d/no-prompt.conf"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.51"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install tailscale
    provisioner "remote-exec" {
        inline = [
        "echo 'Waiting for cloud-init to finish...'",
        "cloud-init status --wait",
        "sudo apt update",
        "sudo apt upgrade -y",
        "sudo curl -fsSL https://tailscale.com/install.sh | sh",
        "sleep 20",
        "sudo tailscale up --authkey ${var.tailscale_auth_key}"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.51"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.51'"
    } 

    # # install docker
    # provisioner "local-exec" {
    #     working_dir = "/home/saul/ansible/"
    #     command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.51,"
    # }

}

#############################################################
# ubuntu 22 worker node 2 --> k3s (using template)          #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s-worker-2" {
    name        = "k3s-worker-2"
    description = "k3s worker 2"
    node_name = "pve1"
    vm_id     = 212
    on_boot = false
    started = true

    agent {
        enabled = true
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.52/24"
                gateway = "192.168.1.127"
        }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225", "192.168.1.1"]
        }
        user_account {
          username = "ubuntu"
          keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }

    }

    network_device {
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        interface    = "scsi0"
        file_format = "raw"
        size = 20
        path_in_datastore = "vm-212-disk-0" 
    }

    cpu {
        architecture = "x86_64"
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 4096
    }

    vga {
        type = "serial0"
    }

    clone {
        vm_id = 201
        full = true
    }

    # skip pending kernel upgrade 
    provisioner "remote-exec" {
        inline = [
        "echo '$nrconf{restart} = 'a';' | sudo tee -a /etc/needrestart/conf.d/no-prompt.conf"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.52"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install tailscale
    provisioner "remote-exec" {
        inline = [
        "echo 'Waiting for cloud-init to finish...'",
        "cloud-init status --wait",
        "sudo apt update",
        "sudo apt upgrade -y",
        "sudo curl -fsSL https://tailscale.com/install.sh | sh",
        "sleep 20",
        "sudo tailscale up --authkey ${var.tailscale_auth_key}"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.52"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.52'"
    } 

}

