#!/bin/bash

RELEASE=38
VARIANT="silverblue-main"
VOLUME_ID="UniversalBlue-${RELEASE}"
selected_mirror="$(curl -s 'https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64' | awk 'NR==2')"
IMAGE_REF="ghcr.io/ublue-os/${VARIANT}"

lorax \
    --product="Fedora" \
    --version="${RELEASE}" \
    --release="${RELEASE}" \
    --source="${selected_mirror}" \
    --variant="${VARIANT}" \
    --nomacboot \
    --volid="${VOLUME_ID}" \
    --rootfs-size 8 \
    --force \
    --add-template-var ostree_oci_ref="${IMAGE_REF}" \
    --add-template-var ostree_osname="${VARIANT}" \
    --add-template "$PWD/lorax-templates/ostree-based-installer/lorax-configure-repo.tmpl" \
    --add-template "$PWD/lorax-templates/ostree-based-installer/lorax-embed-repo.tmpl" \
    "build/offline_${VARIANT}"
