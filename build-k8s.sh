#!/bin/sh
export PATH=$PATH:~/.rd/bin
echo "== Building Raspi OS Lite arm64 K8s image =="
sleep 1
docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build raspios-lite-arm64-k8s.json