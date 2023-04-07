#!/bin/sh

export PS4='+ ${FUNCNAME[0]:-main}:${LINENO}> '
set -ouex pipefail

# Global state, please keep to a minimum
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly WORK_DIR="$(mktemp -d -p "$SCRIPT_DIR")"
if [[ ! "${WORK_DIR}" || ! -d "${WORK_DIR}" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

cleanup() {      
  sudo umount "${WORK_DIR}/overlay/EFI" || true
  #rm -rf "${WORK_DIR}"
}
trap cleanup EXIT ERR

# Main Function for the script
main() {
    readonly INPUT_ISO="$1"
    readonly OUTPUT_ISO="${SCRIPT_DIR}/$(basename "${2:-output.iso}")"

    # ISO release version and architecture are embedded in .discinfo
    xorriso -indev "${INPUT_ISO}" -osirrox on -extract /.discinfo "${WORK_DIR}/.discinfo"

    readonly RELEASE="$(sed "2q;d" "${WORK_DIR}/.discinfo")"
    readonly ARCH="$(sed "3q;d" "${WORK_DIR}/.discinfo")"
    readonly VOLUME_ID="$(xorriso -indev "${INPUT_ISO}" -pvd_info 2> /dev/null | awk '/^Volume Id/{print $NF}')"

    # Splice ESP.img from Original ISO
    ESP_IMG="$(mkesp "${INPUT_ISO}")"
    mkdir -p "${WORK_DIR}/overlay/EFI"
    sudo mount -o loop "${ESP_IMG}" "${WORK_DIR}/overlay/EFI"

    # Prepare overlay
    readonly EFI_ROOT="${WORK_DIR}/overlay/EFI"
    sudo mkdir -p "${EFI_ROOT}/EFI/BOOT"
    sudo mkdir -p "${WORK_DIR}/overlay/boot/grub2"

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

    tree "${WORK_DIR}"
    for GRUB_CFG in "${EFI_GRUB_CFG_FILES[@]}"; do
        ansible -m template \
            --become \
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
            --become \
            -e "VOLUME_ID=${VOLUME_ID}" \
            -e "RELEASE=${RELEASE}" \
            -a "src=${SCRIPT_DIR}/installer/overlay/${ARCH}/${GRUB_CFG}
                dest=${WORK_DIR}/overlay/${GRUB_CFG}" \
            localhost
    done
}

generate_ks() {
    sudo cp -rv "${SCRIPT_DIR}/installer/ks.cfg" "${WORK_DIR}/overlay"
    sudo cp -rv "${SCRIPT_DIR}/installer/kickstart" "${WORK_DIR}/overlay"
    sudo cp -rv "${SCRIPT_DIR}/installer/kickstart" "${EFI_ROOT}/kickstart"
    sudo cp -rv "${SCRIPT_DIR}/installer/ks.cfg" "${EFI_ROOT}"
}

get_esp_offset() {
    IMG_FILE="$1"
    parted --json --script "${IMG_FILE}" \
        unit b \
        print list \
        | jq --raw-output '
            .disk.partitions[] 
            | select(.number == 2)
            | .start[:-1]'
}

get_esp_size() {
    IMG_FILE="$1"
    parted --json --script "${IMG_FILE}" \
        unit b \
        print list \
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
    #XORRISO_REPLAY_FLAGS=($(xorriso -indev "${INPUT_ISO}" -report_el_torito cmd))
    cat > el_torito.log <<EOF
stdio_sync off
padding 0
EOF

    xorriso -indev "${INPUT_ISO}" -report_el_torito cmd \
        | awk '!/append_partition/ && !/efi_path/' \
        | sed 's/^-//' \
        | tee -a el_torito.log

    cat >> el_torito.log <<EOF
padding 0
map ${WORK_DIR}/overlay /
boot_image isolinux partition_entry=gpt_basdat
append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B ${ESP_IMG}
boot_image any efi_path=--interval:appended_partition_2:all::
EOF

    xorriso \
        -indev "${INPUT_ISO}" \
        -outdev "${OUTPUT_ISO}" \
        -options_from_file el_torito.log

    implantisomd5 "${OUTPUT_ISO}"
    echo "Created ISO: ${OUTPUT_ISO}"
}

main "$@"
