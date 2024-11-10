#!/bin/sh
export INSTALL_K3S_SKIP_DOWNLOAD=true
# see /etc/rancher/k3s/config.yaml ?
export INSTALL_K3S_EXEC="server --docker \
                                --flannel-backend=host-gw \
                                --disable=servicelb \
                                --disable=traefik \
                                --disable-cloud-controller \
                                --disable-helm-controller \
                                --cluster-init"   
./get.k3s.sh