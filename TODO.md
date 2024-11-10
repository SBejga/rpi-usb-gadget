# todo

pre download images?
- docker save?
- docker save myimage:latest | gzip > myimage_latest.tar.gz
- zstd?
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo curl -L -o /var/lib/rancher/k3s/agent/images/k3s-airgap-images-amd64.tar.zst "https://github.com/k3s-io/k3s/releases/download/v1.29.1-rc2%2Bk3s1/k3s-airgap-images-amd64.tar.zst"