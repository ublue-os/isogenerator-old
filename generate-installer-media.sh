#!/bin/sh

set -ouex pipefail

readonly INPUT_ISO="$1"
readonly OUTPUT_ISO="${2:-output.iso}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WORK_DIR="$(mktemp -d -p "$SCRIPT_DIR")"

if [[ ! "${WORK_DIR}" || ! -d "${WORK_DIR}" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

cleanup() {      
  rm -rf "${WORK_DIR}"
}

trap cleanup EXIT

# ISO release version and architecture are embedded in .discinfo
xorriso -indev "${INPUT_ISO}" -osirrox on -extract /.discinfo "${WORK_DIR}/.discinfo"

readonly RELEASE="$(sed "2q;d" "${WORK_DIR}/.discinfo")"
readonly ARCH="$(sed "3q;d" "${WORK_DIR}/.discinfo")"

readonly VOLUME_ID="$(xorriso -indev "${INPUT_ISO}" -pvd_info 2> /dev/null | grep "^Volume Id" | cut -d ":" -f2 | awk '{$1=$1};1')"

ISO_FILE="${WORK_DIR}/$(basename "${OUTPUT_ISO}")"

cp -ar "${SCRIPT_DIR}/installer/overlay/${ARCH}" "${WORK_DIR}/overlay"
cp -ar "${SCRIPT_DIR}/installer/kickstart" "${WORK_DIR}/overlay/kickstart"

for GRUB_CONFIG in ${WORK_DIR}/overlay/{boot/grub2/grub.cfg,EFI/BOOT/{grub.cfg,BOOT.conf}}; do
    if [[ -f "${GRUB_CONFIG}" ]]; then
        sed -i "s@\${{ RELEASE }}@${RELEASE}@g" "${GRUB_CONFIG}"
        sed -i "s@\${{ VOLUME_ID }}@${VOLUME_ID}@g" "${GRUB_CONFIG}"
	grub2-script-check --verbose "${GRUB_CONFIG}"
    fi
done

xorriso -indev "${INPUT_ISO}" -outdev "${ISO_FILE}" -boot_image any replay -map "${WORK_DIR}/overlay" /

implantisomd5 "${ISO_FILE}"

mv "${ISO_FILE}" "${OUTPUT_ISO}"

echo "Created ISO: ${OUTPUT_ISO}"
