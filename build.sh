#!/bin/sh
export PATH=$PATH:~/.rd/bin
docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build raspios-lite-arm64.json