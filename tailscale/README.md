# Tailscale

Tailscale is a **zero-config VPN** for building secure networks.  
Just install Tailscale on each device/server and they’ll automatically connect in a secure mesh network.

---

## Why Tailscale?

It's the only way anything in this homelab talks to the outside world — I never expose a service directly to the internet. I use it for remote access to the LAN, sharing specific things like Plex with friends, and routing Prometheus/Loki metrics and logs between the cluster and hosts that aren't on the same network.

---

## Install Tailscale

### On Linux VM
```sh
sudo apt update
sudo apt upgrade -y
sudo apt install curl -y
curl -fsSL https://tailscale.com/install.sh | sh
# Register manually
sudo tailscale up
# Or automatically with auth key
sudo tailscale up --authkey ${var.tailscale_auth_key}
```

### On LXC Container
```sh
# Allow tun access on Proxmox host
echo 'lxc.cgroup.devices.allow: c 10:200 rwm' >> /etc/pve/lxc/114.conf
echo 'lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' >> /etc/pve/lxc/114.conf

# Install Tailscale on LXC
apt update
apt upgrade -y
apt install curl -y
curl -fsSL https://tailscale.com/install.sh | sh
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
reboot -f

# Register Tailscale
tailscale up
# Or automatically
tailscale up --authkey ${var.tailscale_auth_key}
```

### On Kubernetes (K8s)
- Use the [Tailscale Operator](https://tailscale.com/learn/managing-access-to-kubernetes-with-tailscale).
- Add an annotation to your Service:
```yaml
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