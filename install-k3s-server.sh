#!/bin/sh
export INSTALL_K3S_EXEC="server --docker \
                                --flannel-backend=host-gw \
                                --disable=servicelb \
                                --disable=traefik \
                                --disable-cloud-controller \
                                --disable-helm-controller \
                                --tls-san "walpi0.local" \
                                --node-label "pi=5" \
                                --node-label "ram=4G" \
                                --cluster-init"   
./get.k3s.sh