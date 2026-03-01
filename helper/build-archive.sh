#!/usr/bin/bash

set -e

if [[ "${ARCH}" == "arm64" ]]; then
	ARCHIVE_ARCH=aarch64
fi

if mountpoint -q ${BUILD_DIR}/dev; then
	echo "[*] Unmounting"
	umount ${BUILD_DIR}/dev/pts
	umount ${BUILD_DIR}/dev
	umount ${BUILD_DIR}/proc
	umount ${BUILD_DIR}/sys
	umount ${BUILD_DIR}/run
fi

BUILD_ARCHIVE="${READ_PATH}/build_arhive/"
OUTPUT="${BUILD_ARCHIVE}/netopsy-${NETHYDRA_VERSION}-${ARCHIVE_ARCH}.tar.xz"

if [[ "${BUILD_WITH_DESKTOP}" == "true" ]]; then
	OUTPUT="${BUILD_ARCHIVE}/netopsy-${NETHYDRA_VERSION}-${ARCHIVE_ARCH}-desktop.tar.xz"
fi

echo "[*] Creating image archive at $OUTPUT"
mkdir -p $BUILD_ARCHIVE
XZ_OPT=-9 tar -C "${BUILD_DIR}" -cJf "$OUTPUT" .

