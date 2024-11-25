# k8s at Pi

## with

- k8s 1.30 + docker
- flannel via helm and pod CIDR

## Install

```bash
# setup
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --token-ttl 0 --cri-socket=unix:///var/run/cri-dockerd.sock
sudo chmod 755 /etc/kubernetes/admin.conf

# flannel
kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged
helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="192.168.0.0/16" --namespace kube-flannel flannel/flannel

# join
sudo kubeadm join 10.0.10.60:6443 --cri-socket=unix:///var/run/cri-dockerd.sock \
	--token smlgvo.8byf9cgozwq7ih72 \
	--discovery-token-ca-cert-hash sha256:81977a5718b47a0f670cbd9d875437f3ae3e9175bc99855fe2dbc6753b358754
```

> scp walpi0.local:/etc/kubernetes/admin.conf ~/.kube/walpi0.yaml

## test

kubectl run nginx --image=nginx --port=80
kubectl expose pod nginx --port=8080 --target-port=80 --type NodePort

> k delete svc nginx && k delete pod nginx
