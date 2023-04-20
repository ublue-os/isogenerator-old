#!/bin/sh

set -oue pipefail

readonly SECUREBOOT_KEY="$1"
readonly ENROLLMENT_PASSWORD="$2"

if [[ ! -d "/sys/firmware/efi" ]]; then
    echo "EFI mode not detected. Skipping key enrollment."
    exit 0
fi

if [[ ! -f "${SECUREBOOT_KEY}" ]]; then
    echo "Secure boot key not found: ${SECUREBOOT_KEY}"
    exit 1
fi

echo -e "${ENROLLMENT_PASSWORD}\n${ENROLLMENT_PASSWORD}" | mokutil --import "${SECUREBOOT_KEY}" ||:
