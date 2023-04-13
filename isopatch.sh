#!/bin/bash

export PS4='+ \e[31m${FUNCNAME[0]:-isopatch}\e[39m:\e[97m${LINENO}\e[39m:> '
set -ouex pipefail

# Global state, please keep to a minimum
# shellcheck disable=SC2155
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck disable=SC2155
readonly WORK_DIR="$(mktemp -d -p "$SCRIPT_DIR")"
if [[ ! "${WORK_DIR}" || ! -d "${WORK_DIR}" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

cleanup() {      
    sudo umount "${WORK_DIR}/overlay/EFI" || true
    rm -rf "${WORK_DIR}"
}
trap cleanup EXIT ERR

# Main Function for the script
main() {
    # shellcheck disable=SC2155
    readonly INPUT_ISO="$1"
    # shellcheck disable=SC2155
    readonly OUTPUT_ISO="${SCRIPT_DIR}/$(basename "${2:-output.iso}")"

    # ISO release version and architecture are embedded in .discinfo
    xorriso -indev "${INPUT_ISO}" -osirrox on -extract /.discinfo "${WORK_DIR}/.discinfo"

    # shellcheck disable=SC2155
    readonly RELEASE="$(sed "2q;d" "${WORK_DIR}/.discinfo")"
    # shellcheck disable=SC2155
    readonly ARCH="$(sed "3q;d" "${WORK_DIR}/.discinfo")"
    # shellcheck disable=SC2155
    readonly VOLUME_ID="$(xorriso -indev "${INPUT_ISO}" -pvd_info 2> /dev/null | awk '/^Volume Id/{print $NF}')"

    # Splice ESP.img from Original ISO
    # shellcheck disable=SC2155
    readonly ESP_IMG="$(mkesp "${INPUT_ISO}")"

    # Prepare overlay
    # shellcheck disable=SC2155

    patch_grub_cfg 
    generate_ks

    sudo umount "${ESP_IMG}"
    generate_bootable_iso
}

patch_grub_cfg() {
    EFI_GRUB_CFG_FILES=(
        EFI/BOOT/grub.cfg
        EFI/BOOT/BOOT.conf
    )

    readonly EFI_ROOT="${WORK_DIR}/overlay/EFI"
    mkdir -p "${WORK_DIR}/overlay/boot/grub2"
    mkdir -p "${WORK_DIR}/overlay/EFI/BOOT"

    tree "${WORK_DIR}"
    for GRUB_CFG in "${EFI_GRUB_CFG_FILES[@]}"; do
        ansible -m template \
            -e @boot_menu.yml \
            -e "BOOT_TYPE=efi" \
            -e "VOLUME_ID=${VOLUME_ID}" \
            -e "RELEASE=${RELEASE}" \
            -a "src=${SCRIPT_DIR}/installer/overlay/${ARCH}/${GRUB_CFG}
                dest=${WORK_DIR}/overlay/${GRUB_CFG}" \
            localhost
    done

    sudo mount -o loop "${ESP_IMG}" "${WORK_DIR}/overlay/EFI"
    sudo mkdir -p "${EFI_ROOT}/EFI/BOOT"

    tree "${WORK_DIR}"
    for GRUB_CFG in "${EFI_GRUB_CFG_FILES[@]}"; do
        ansible -m template \
            --become \
            -e @boot_menu.yml \
            -e "BOOT_TYPE=efi" \
            -e "VOLUME_ID=${VOLUME_ID}" \
            -e "RELEASE=${RELEASE}" \
            -a "src=${SCRIPT_DIR}/installer/overlay/${ARCH}/${GRUB_CFG}
                dest=${EFI_ROOT}/${GRUB_CFG}" \
            localhost
    done

    MBR_GRUB_CFG_FILES=(
        boot/grub2/grub.cfg
    )
    for GRUB_CFG in "${MBR_GRUB_CFG_FILES[@]}"; do
        ansible -m template \
            -e @boot_menu.yml \
            -e "BOOT_TYPE=mbr" \
            -e "VOLUME_ID=${VOLUME_ID}" \
            -e "RELEASE=${RELEASE}" \
            -a "src=${SCRIPT_DIR}/installer/overlay/${ARCH}/${GRUB_CFG}
                dest=${WORK_DIR}/overlay/${GRUB_CFG}" \
            localhost
    done
}

generate_ks() {
    cp -rv "${SCRIPT_DIR}/installer/kickstart" "${WORK_DIR}/overlay"
    sudo cp -rv "${SCRIPT_DIR}/installer/kickstart" "${EFI_ROOT}/kickstart"
}

get_esp_offset() {
    IMG_FILE="$1"
    parted --json --script "${IMG_FILE}" \
        unit b \
        print \
        | jq --raw-output '
            .disk.partitions[] 
            | select(.number == 2)
            | .start[:-1]'
}

get_esp_size() {
    IMG_FILE="$1"
    parted --json --script "${IMG_FILE}" \
        unit b \
        print \
        | jq --raw-output '
            .disk.partitions[] 
            | select(.number == 2)
            | .size[:-1]'
}

mkesp() {
    IMG_FILE="$1"

    ESP_OFFSET="$(get_esp_offset "${INPUT_ISO}")"
    ESP_SIZE="$(get_esp_size "${INPUT_ISO}")"
    echo "ESP Partition detected at offset: ${ESP_OFFSET}" >&2

    dd bs=1 \
        skip="${ESP_OFFSET}" \
        count="${ESP_SIZE}" \
        if="${IMG_FILE}" \
        of="${WORK_DIR}/esp.img"

    echo "${WORK_DIR}/esp.img"
}

generate_bootable_iso() {

    {
        cat <<EOF
stdio_sync off
padding 0
EOF

        xorriso -indev "${INPUT_ISO}" -report_el_torito cmd \
            | awk '!/append_partition/ && !/efi_path/' \
            | sed 's/^-//'

        cat <<EOF
padding 0
map ${WORK_DIR}/overlay /
boot_image isolinux partition_entry=gpt_basdat
append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B ${ESP_IMG}
boot_image any efi_path=--interval:appended_partition_2:all::
EOF
    } | tee el_torito.log

    xorriso \
        -indev "${INPUT_ISO}" \
        -outdev "${OUTPUT_ISO}" \
        -options_from_file el_torito.log

    implantisomd5 "${OUTPUT_ISO}"
    echo "Created ISO: ${OUTPUT_ISO}"

    sha256sum --tag "${OUTPUT_ISO}" | tee "${OUTPUT_ISO}.sha256sum"
}

main "$@"
