#######
# LXC #
#######
#########################################################
# Ubuntu 22 lxc ct for homepage --> homepage 110        #
#########################################################
resource "proxmox_virtual_environment_container" "homepage" {
    node_name = "pve1"
    vm_id = 110
    description = "homepage lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "homepage"
        ip_config {
            ipv4 {
                address = "192.168.1.10/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }
    

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    cpu {
        cores = 1
    }

    memory {
      dedicated = 1024
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

  # allow tun access 
  provisioner "remote-exec" {
    inline = [
      "echo 'lxc.cgroup.devices.allow: c 10:200 rwm' >> /etc/pve/lxc/110.conf",
      "echo 'lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' >> /etc/pve/lxc/110.conf",    ]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.1.127"
      private_key = file ("/home/saul/.ssh/prox_ssh")
    }  
  }
  
  # install tailscale on lxc 
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt upgrade -y",
      "apt install curl -y",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf",
      "echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf",
      "sysctl -p /etc/sysctl.conf",
      "reboot -f"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.1.10"
      private_key = file ("/home/saul/.ssh/prox_ssh")
    }  
  }

  # register tailscale
  provisioner "remote-exec" {
    inline = [
      "tailscale up --authkey ${var.tailscale_auth_key}"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.1.10"
      private_key = file ("/home/saul/.ssh/prox_ssh")
    }  
  }

  # install docker 
  provisioner "local-exec" {
    working_dir = "/home/saul/ansible/"
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.10,"
  }

}

#########################################################
# Ubuntu 22 lxc ct for adguard --> adguard 111          #
#########################################################
resource "proxmox_virtual_environment_container" "adguard" {
    node_name = "pve1"
    vm_id = 111
    description = "adguard lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "adguard"
        ip_config {
            ipv4 {
                address = "192.168.1.11/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.1"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    cpu {
        cores = 1
    }

    memory {
      dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt update",
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.11"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker 
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.11,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for kavita --> kavita 112            #
#########################################################
resource "proxmox_virtual_environment_container" "kavita" {
    node_name = "pve1"
    vm_id = 112
    description = "kavita lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "kavita"
        ip_config {
            ipv4 {
                address = "192.168.1.12/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 2
    }

    memory {
      dedicated = 1024
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt update",
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.12"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker 
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.12,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for vaulwarden --> vaultwarden 113   #
#########################################################
resource "proxmox_virtual_environment_container" "vaultwarden" {
    node_name = "pve1"
    vm_id = 113
    description = "vaultwarden lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "vaultwarden"
        ip_config {
            ipv4 {
                address = "192.168.1.13/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    cpu {
        cores = 1
    }

    memory {
      dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt update",
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.13"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker 
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.12,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for plex --> plex 114                #
#########################################################
resource "proxmox_virtual_environment_container" "plex" {
    node_name = "pve1"
    vm_id = 114
    description = "plex lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "plex"
        ip_config {
            ipv4 {
                address = "192.168.1.14/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 20
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    device_passthrough {
        path = "/dev/dri/renderD128"
        gid = 103
        mode = "0666"
    }

    device_passthrough {
        path = "/dev/dri/card0"
        gid = 44
        mode = "0666"
    }

    cpu {
        cores = 2
    }

    memory {
        dedicated = 4096
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # allow tun access
    provisioner "remote-exec" {
        inline = [
        "echo 'lxc.cgroup.devices.allow: c 10:200 rwm' >> /etc/pve/lxc/114.conf",
        "echo 'lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' >> /etc/pve/lxc/114.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.127"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }
    
    # install tailscale on lxc 
    provisioner "remote-exec" {
        inline = [
        "apt update",
        "apt upgrade -y",
        "apt install curl -y",
        "curl -fsSL https://tailscale.com/install.sh | sh",
        "echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf",
        "echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf",
        "sysctl -p /etc/sysctl.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.14"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # register tailscale
    provisioner "remote-exec" {
        inline = [
        "tailscale up --authkey ${var.tailscale_auth_key}"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.14"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker 
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.14,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for deluge --> deluge 115            #
#########################################################
resource "proxmox_virtual_environment_container" "deluge" {
    node_name = "pve1"
    vm_id = 115
    description = "deluge lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "deluge"
        ip_config {
            ipv4 {
                address = "192.168.1.15/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.15"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.15,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for jackett --> jackett 116          #
#########################################################
resource "proxmox_virtual_environment_container" "jackett" {
    node_name = "pve1"
    vm_id = 116
    description = "jackett lxc"
    unprivileged = true
    start_on_boot = true
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "jackett"
        ip_config {
            ipv4 {
                address = "192.168.1.16/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.16"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.16,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for radarr --> radarr 117            #
#########################################################
resource "proxmox_virtual_environment_container" "radarr" {
    node_name = "pve1"
    vm_id = 117
    description = "radarr lxc"
    unprivileged = true
    start_on_boot = false
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "radarr"
        ip_config {
            ipv4 {
                address = "192.168.1.17/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.17"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.17,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for sonarr --> sonarr 118            #
#########################################################
resource "proxmox_virtual_environment_container" "sonarr" {
    node_name = "pve1"
    vm_id = 118
    description = "sonarr lxc"
    unprivileged = true
    start_on_boot = false
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "sonarr"
        ip_config {
            ipv4 {
                address = "192.168.1.18/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.18"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.18,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for tautuilli --> tautulli 119       #
#########################################################
resource "proxmox_virtual_environment_container" "tautulli" {
    node_name = "pve1"
    vm_id = 119
    description = "tautulli lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "tautulli"
        ip_config {
            ipv4 {
                address = "192.168.1.19/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.19"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.19,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for nginx --> nginx 120              #
#########################################################
resource "proxmox_virtual_environment_container" "nginx" {
    node_name = "pve1"
    vm_id = 120
    description = "nginx lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "nginx"
        ip_config {
            ipv4 {
                address = "192.168.1.20/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.20"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.20,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for playground --> playground 121    #
#########################################################
resource "proxmox_virtual_environment_container" "playground" {
    node_name = "pve1"
    vm_id = 121
    description = "playground lxc"
    unprivileged = true
    start_on_boot = false
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "playground"
        ip_config {
            ipv4 {
                address = "192.168.1.21/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 20
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 1024
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt update",
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.21"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.21,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for amule --> amule 122              #
#########################################################
resource "proxmox_virtual_environment_container" "amule" {
    node_name = "pve1"
    vm_id = 122
    description = "amule lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "amule"
        ip_config {
            ipv4 {
                address = "192.168.1.22/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.22"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.22,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for handbrake --> handbrake 123      #
#########################################################
resource "proxmox_virtual_environment_container" "handbrake" {
    node_name = "pve1"
    vm_id = 123
    description = "handbrake lxc"
    unprivileged = true
    start_on_boot = false
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "handbrake"
        ip_config {
            ipv4 {
                address = "192.168.1.23/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 5
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 4
    }

    memory {
        dedicated = 2048
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.23"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.23,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for bookstack --> bookstack 124      #
#########################################################
resource "proxmox_virtual_environment_container" "bookstack" {
    node_name = "pve1"
    vm_id = 124
    description = "bookstack lxc"
    unprivileged = true
    start_on_boot = true

    features {
        nesting = true
    }

    initialization {
        hostname = "bookstack"
        ip_config {
            ipv4 {
                address = "192.168.1.24/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

  # allow tun access 
  provisioner "remote-exec" {
    inline = [
      "echo 'lxc.cgroup.devices.allow: c 10:200 rwm' >> /etc/pve/lxc/124.conf",
      "echo 'lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' >> /etc/pve/lxc/124.conf",    ]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.1.127"
      private_key = file ("/home/saul/.ssh/prox_ssh")
    }  
  }
  
  # install tailscale on lxc 
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt upgrade -y",
      "apt install curl -y",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf",
      "echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf",
      "sysctl -p /etc/sysctl.conf",
      "reboot -f"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.1.24"
      private_key = file ("/home/saul/.ssh/prox_ssh")
    }  
  }

  # register tailscale
  provisioner "remote-exec" {
    inline = [
      "tailscale up --authkey ${var.tailscale_auth_key}"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.1.24"
      private_key = file ("/home/saul/.ssh/prox_ssh")
    }  
  }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.24,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for minio --> minio 125              #
#########################################################
resource "proxmox_virtual_environment_container" "minio" {
    node_name = "pve1"
    vm_id = 125
    description = "minio lxc"
    unprivileged = true
    start_on_boot = false
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "minio"
        ip_config {
            ipv4 {
                address = "192.168.1.25/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 50
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 1024
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "touch /etc/.pve-ignore.resolv.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.25"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.25'"
    } 

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.25,"
    }

}

#########################################################
# Ubuntu 22 lxc ct for nfs --> nfs 126                  #
#########################################################
resource "proxmox_virtual_environment_container" "nfs" {
    node_name = "pve1"
    vm_id = 126
    description = "nfs lxc"
    unprivileged = false
    start_on_boot = false
    started = false

    features {
        nesting = true
    }

    initialization {
        hostname = "nfs"
        ip_config {
            ipv4 {
                address = "192.168.1.26/24"
                gateway = "192.168.1.127"
            }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
        }
        user_account {
                keys = [(var.proxmox_ssh_key),(var.ansible_ssh_key)]        
        }
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 10
    }

    mount_point {
        volume = "/mnt/pve/local-storage"
        path   = "/mnt/local-storage"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    operating_system {
        template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        type             = "ubuntu"
    }

    # do not change dns
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "touch /etc/.pve-ignore.resolv.conf",
        "reboot -f"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.26"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # add unconfined
    provisioner "remote-exec" {
        inline = [
        "echo 'lxc.apparmor.profile: unconfined' >> /etc/pve/lxc/126.conf"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.127"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install nfs
    provisioner "remote-exec" {
        inline = [
        "apt upgrade -y",
        "apt install nfs-kernel-server -y"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.26"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # configure nfs
    provisioner "remote-exec" {
        inline = [
        "echo '/mnt/nfs 192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)' >> /etc/exports",
        "exportfs -a",
        "chown nobody:nogroup",  
        "chmod ugo+rwx /mnt/nfs",
        "systemctl restart nfs-kernel-server"
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.26"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i root@192.168.1.26,"
    }

}

#######
# VMS #
#######
#############################################################
# ubuntu 22 master and worker node --> k3s (using template) #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s" {
    name        = "k3s"
    description = "k3s master and worker"
    node_name = "pve1"
    vm_id     = 210
    on_boot = false
    started = false

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
                servers = ["192.168.1.225"]
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
        size = 50
        path_in_datastore = "vm-210-disk-0" 
    }

    cpu {
        architecture = "x86_64"
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 8192
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

    # pass disk partition to VM
    provisioner "remote-exec" {
        inline = [
        "qm set 210 -scsi2 /dev/disk/by-id/ata-ST2000LM015-2E8174_WY21FGDF-part1"        
        ]
        connection {
        type        = "ssh"
        user        = "root"
        host        = "192.168.1.127"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # mount disk partition
    provisioner "remote-exec" {
        inline = [
        "sudo mkdir /mnt/local-storage",
        "echo '/dev/sdb    /mnt/local-storage    ext4    defaults    0    0' | sudo tee -a /etc/fstab",
        "sudo mount -a",
        "sudo systemctl daemon-reload",
        "sleep 10"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.50"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # update number of files a process can open
    provisioner "remote-exec" {
        inline = [
        "echo 'root soft nofile 4096' | sudo tee -a /etc/security/limits.conf",
        "echo 'fs.inotify.max_user_instances=256' | sudo tee -a /etc/sysctl.conf"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.50"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # install docker 
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install-docker-ubuntu.yaml -i ubuntu@192.168.1.50,"
    } 

    # remove keyring warning
    provisioner "remote-exec" {
        inline = [
        "sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d"
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

    # install K3S
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/k3s-ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook site.yml -i ./inventory/my-cluster/hosts.ini"
    }

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.50'"
    } 

    # retrieve kubeconfig
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "scp k3s:~/.kube/config /home/saul/.kube/config"
    } 

    # install argocd and apps
    provisioner "local-exec" {
        working_dir = "/home/saul/k3s"
        command = "./install.sh"
    }     

    # reboot host
    provisioner "remote-exec" {
        inline = [
        "sudo reboot"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.50"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }
}

#############################################################
# ubuntu 22 master --> k3s (using template)                 #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s-master" {
    name        = "k3s-master"
    description = "k3s master"
    node_name = "pve1"
    vm_id     = 211
    on_boot = false
    started = false

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
                servers = ["192.168.1.225"]
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
        size = 30
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

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.51'"
    } 

}

#############################################################
# ubuntu 22 worker node 1 --> k3s (using template)          #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s-worker-1" {
    name        = "k3s-worker-1"
    description = "k3s worker 1"
    node_name = "pve1"
    vm_id     = 212
    on_boot = false
    started = false

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
                servers = ["192.168.1.225"]
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
        size = 30
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

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.52'"
    } 

}

#############################################################
# ubuntu 22 worker node 2 --> k3s (using template)          #
#############################################################
resource "proxmox_virtual_environment_vm" "k3s-worker-2" {
    name        = "k3s-worker-2"
    description = "k3s worker 2"
    node_name = "pve1"
    vm_id     = 213
    on_boot = false
    started = false

    agent {
        enabled = true
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.53/24"
                gateway = "192.168.1.127"
        }
        }
        dns {
                domain = "home-network.io"
                servers = ["192.168.1.225"]
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
        size = 30
        path_in_datastore = "vm-213-disk-0" 
    }

    cpu {
        architecture = "x86_64"
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 4096
    }

    clone {
        vm_id = 201
        full = true
    }
    
    # depends on
    depends_on = [proxmox_virtual_environment_vm.k3s-master, proxmox_virtual_environment_vm.k3s-worker-1]

    # skip pending kernel upgrade 
    provisioner "remote-exec" {
        inline = [
        "echo '$nrconf{restart} = 'a';' | sudo tee -a /etc/needrestart/conf.d/no-prompt.conf"
        ]
        connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "192.168.1.53"
        private_key = file ("/home/saul/.ssh/prox_ssh")
        }  
    }

    # remove ssh key from known hosts
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "ssh-keygen -f '/home/saul/.ssh/known_hosts' -R '192.168.1.53'"
    } 

    # install K3S
    provisioner "local-exec" {
        working_dir = "/home/saul/ansible/k3s-ansible/"
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook site.yml -i ./inventory/my-cluster/hosts.ini"
    }

    # retrieve kubeconfig
    provisioner "local-exec" {
        working_dir = "/home/saul"
        command = "scp k3s-master:~/.kube/config /home/saul/.kube/config"
    } 

    # install argocd and apps
    provisioner "local-exec" {
        working_dir = "/home/saul/k3s"
        command = "./install.sh"
    }    

}