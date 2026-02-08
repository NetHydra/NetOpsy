#!/usr/bin/bash

set -e

cp /usr/bin/qemu-aarch64-static ${BUILD_DIR}/usr/bin/

if [[ ! -e ${BUILD_DIR}/debootstrap ]]; then
	echo "Continue current build"
else
	echo "[*] Extracting base fs..."
	chroot ${BUILD_DIR} /debootstrap/debootstrap --second-stage
fi

cat <<EOF> ${BUILD_DIR}/etc/apt/sources.list.d/nethydra-mirror.sources
Types: deb
URIs: ${NETHYDRA_MIRROR}
Suites: ${CODENAME}
Components: main non-free
Signed-By: /usr/share/keyrings/${NETHYDRA_MIRROR_KEYRING}
EOF
