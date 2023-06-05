#!/bin/sh

set -oue pipefail

DEFAULT_URL="ghcr.io/ublue-os/silverblue-main:38"

for ARG in `cat /proc/cmdline`; do
    if [[ "${ARG}" =~ ^imageurl= ]]; then
         URL="${ARG#*=}"
    fi
done

URL=$(echo "${URL:-${DEFAULT_URL}}" | tr "[:upper:]" "[:lower:]")

readonly RELEASE="$(sed "2q;d" "/run/install/repo/.discinfo")"
readonly ARCH="$(sed "3q;d" "/run/install/repo/.discinfo")"

cat << EOL > /tmp/ks-urls.txt
ostreecontainer --url="${URL}" --no-signature-verification
url --url="https://download.fedoraproject.org/pub/fedora/linux/{{ REPO }}/${RELEASE}/Everything/${ARCH}/os/"
EOL
