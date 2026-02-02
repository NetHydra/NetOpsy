#!/usr/bin/bash

set -e

echo "[*] Extracting base fs..."
chroot ${BUILD_DIR} /debootstrap/debootstrap --second-stage

cat <<EOF> ${BUILD_DIR}/etc/apt/sources.list.d/nethydra-mirror.sources
Types: deb
URIs: ${NETHYDRA_MIRROR}
Suites: ${CODENAME}
Components: main non-free
Signed-By: /usr/share/keyrings/${NETHYDRA_MIRROR_KEYRING}
EOF
