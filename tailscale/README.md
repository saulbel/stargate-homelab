# Tailscale

## Why Tailscale
Tailscale is a ``zero config VPN`` for building secure networks. The only thing we have to do is to install tailscale on each of our devices/servers and they will be able to connect with each other as a ``network mesh``

This way you can have all your servers connected and you can even give access to one/multiple server to your friends, for example to share your ``plex server`` or to play on a selfhosted ``game server`` such as project zomboid.

I use it for external access without exposing anything to the internet and to send all the metrics/logs to `prometheus and loki` which are hosted on an `OCI` server.

## Install Tailscale
- Install ``tailscale`` on ``Linux VM``
```
sudo apt update
sudo apt upgrade -y
sudo apt install curl -y
sudo curl -fsSL <https://tailscale.com/install.sh> | sh
# manually
sudo tailscale up
# automatically
sudo tailscale up --authkey ${var.tailscale_auth_key}
```
- Install ``tailscale`` on ``LXC``
```
# allow tun access on proxmox host
echo 'lxc.cgroup.devices.allow: c 10:200 rwm' >> /etc/pve/lxc/114.conf
echo 'lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' >> /etc/pve/lxc/114.conf

# install tailscale on lxc
apt update
apt upgrade -y
apt install curl -y
curl -fsSL https://tailscale.com/install.sh | sh
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
reboot -f

# register tailscale
# manually
tailscale up
# automatically
tailscale up --authkey ${var.tailscale_auth_key}
```
- Install ``tailscale`` on ```K8s```
```
# We use tailscale operator in order to do this --> https://tailscale.com/learn/managing-access-to-kubernetes-with-tailscale
# Then is quite simple, we just have to add an annotation to the Service, for example:
apiVersion: v1
kind: Service
metadata:
  name: hello-v1-svc
  namespace: hello-app
  annotations: 
    external-dns.alpha.kubernetes.io/hostname: helloapp.home
    tailscale.com/expose: "true"
spec:
  selector:
    app: hello-v1
  ports:
  - protocol: TCP
    port: 81
    targetPort: 8080
```