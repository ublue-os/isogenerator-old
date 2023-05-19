#!/bin/sh

set -oue pipefail

source /run/install/repo/kickstart/ublue-os-env-vars

/run/install/repo/kickstart/enroll-secureboot-key.sh "${SECUREBOOT_KEY_OLD}" "${ENROLLMENT_PASSWORD}"
/run/install/repo/kickstart/enroll-secureboot-key.sh "${SECUREBOOT_KEY}" "${ENROLLMENT_PASSWORD}"
