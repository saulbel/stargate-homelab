#############################################################
# install k3s in master/worker nodes                        #
#############################################################
resource "null_resource" "wait_for_nodes_ready" {
  depends_on = [
    proxmox_virtual_environment_vm.k3s-master,
    proxmox_virtual_environment_vm.k3s-worker-1,
    proxmox_virtual_environment_vm.k3s-worker-2
  ]

  # MASTER
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init on master...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",
      "echo 'Cloud-init finished on master'",
      "echo 'Waiting for systemd to settle...'",
      "while systemctl is-system-running | grep -qE 'starting|degraded'; do sleep 5; done",
      "echo 'Systemd stable on master'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "192.168.1.50"
      private_key = file("/home/saul/.ssh/prox_ssh")
    }
  }

  # WORKER 1
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init on worker1...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",
      "echo 'Cloud-init finished on worker1'",
      "echo 'Waiting for systemd to settle...'",
      "while systemctl is-system-running | grep -qE 'starting|degraded'; do sleep 5; done",
      "echo 'Systemd stable on worker1'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "192.168.1.51"
      private_key = file("/home/saul/.ssh/prox_ssh")
    }
  }

  # WORKER 2
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init on worker2...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",
      "echo 'Cloud-init finished on worker2'",
      "echo 'Waiting for systemd to settle...'",
      "while systemctl is-system-running | grep -qE 'starting|degraded'; do sleep 5; done",
      "echo 'Systemd stable on worker2'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "192.168.1.52"
      private_key = file("/home/saul/.ssh/prox_ssh")
    }
  }
}

resource "null_resource" "install_k3s" {
  depends_on = [null_resource.wait_for_nodes_ready]

  provisioner "local-exec" {
    working_dir = "/home/saul/ansible/k3s-ansible/"
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook site.yml -i ./inventory/my-cluster/hosts.ini"
  }
}

resource "null_resource" "retrieve_kubeconfig" {
  depends_on = [null_resource.install_k3s]

  provisioner "local-exec" {
    working_dir = "/home/saul"
    command     = "scp k3s:~/.kube/config /home/saul/.kube/config"
  }
}

resource "null_resource" "install_argocd" {
  depends_on = [null_resource.retrieve_kubeconfig]

  provisioner "local-exec" {
    working_dir = "/home/saul/k3s"
    command     = "./install.sh"
  }
}