#!/bin/bash

RELEASE=38
VARIANT="silverblue-main"
VOLUME_ID="FedoraUniversalBlue-${RELEASE}"
selected_mirror="$(curl -s 'https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64' | awk 'NR==2')"

lorax \
    --product="Fedora" \
    --version="${RELEASE}" \
    --release="${RELEASE}" \
    --source="${selected_mirror}" \
    --variant="${VARIANT}" \
    --nomacboot \
    --volid="${VOLUME_ID}" \
    --rootfs-size 4 \
    --force \
    --add-arch-template-var repo=Release \
    build/netinstall
