# k8s at Pi

- k8s 1.30 + containerd
- flannel or calico

see https://devops.datenkollektiv.de/raspberry-pi-5-a-kubernetes-cluster.html

## Install

```bash
# setup
#old: sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --token-ttl 0 --cri-socket=unix:///var/run/containerd/containerd.sock
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# join
kubeadm join 10.0.10.152:6443 --token ly2qih.vcutkfvfym4han94 \
	--discovery-token-ca-cert-hash sha256:3c018e5cdf193687886a2d2bedf188be7d89c22885d4d4307fb6ddb41fa29fa1

sudo chmod 755 /etc/kubernetes/admin.conf

# check
journalctl -xeu containerd.service -f
k get pods -n kube-system -o wide # with host network ip 10.0.10.x
k get svc -n kube-system # 10.96.0.10
```

## Networking

### A)  NOT: Flannel

```bash
# flannel
# kubectl create ns kube-flannel
# kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged
# helm repo add flannel https://flannel-io.github.io/flannel/
# helm install flannel --set podCidr="192.168.0.0/16" --namespace kube-flannel flannel/flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
k get pods -A -w
```

> fails :-(
> failed" error="failed to destroy network for sandbox \"00f38f0848bd7d5c145df48662c7571a853b053e1aaa7529d6b8accc33f7f3aa\": plugin type=\"flannel\" failed (delete): failed to find plugin \"flannel\" in path [/usr/lib/cni]"

### B) Calico

```bash
# CNI
sudo curl -L -o /usr/lib/cni/calico https://github.com/projectcalico/cni-plugin/releases/download/v3.20.6/calico-arm64
sudo chmod 755 /usr/lib/cni/calico
sudo curl -L -o /usr/lib/cni/calico-ipam https://github.com/projectcalico/cni-plugin/releases/download/v3.20.6/calico-ipam-arm64
sudo chmod 755 /usr/lib/cni/calico-ipam

# install
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml
kubectl get pods -n calico-system -w
```

### C) NOT: cilium

```bash
helm repo add cilium https://helm.cilium.io/
helm upgrade -i cilium cilium/cilium --version 1.16.4 --namespace kube-system --set ipam.mode=cluster-pool --set ipam.operator.clusterPoolIPv4PodCIDRList=["192.168.0.0/16"] --set ipam.operator.clusterPoolIPv4MaskSize=24 --set envoy.enabled=false
helm upgrade -i cilium cilium/cilium --version 1.16.4 --namespace kube-system --set ipam.mode=cluster-pool --set envoy.enabled=false
```

> errors with ciliun-cni not found in path
> found no way to download binaries to /opt/cni/bin

```bash
cilium install
# install gone through
# but coredns stucks in ContainerCreating
# Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "9da2afb0f9a1777b88cd64ffa597941a6ba28b506c0e68afca06c82460a7e0e0": plugin type="cilium-cni" failed (add): failed to find plugin "cilium-cni" in path [/usr/lib/cni]
```

## untaint?

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

## kubeconfig

```bash
scp pi@pi0.local:/etc/kubernetes/admin.conf ~/.kube/pi0.yaml
code ~/.kube/pi0.yaml
```

## test

sudo ctr -n k8s.io containers list

kubectl run nginx --image=nginx --port=80 --overrides='{"spec":{"tolerations":[{"key": "node-role.kubernetes.io/control-plane", "operator":"Exists", "effect":"NoSchedule"}]}}'
kubectl expose pod nginx --port=8080 --target-port=80 --type NodePort
k get svc -o wide

> k delete svc nginx && k delete pod nginx

## hints

- calico works with pod cidr 192.168.0.0/16
- debian 12 bookworm has no vxlan support? `modprobe vxlan`
