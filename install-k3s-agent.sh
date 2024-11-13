#!/bin/sh
export K3S_URL=""
export K3S_TOKEN=""
export INSTALL_K3S_EXEC="agent --docker --node-label pi=5 --node-label ram=4G"
./get.k3s.sh