#!/usr/bin/bash

set -e

mkdir -pv ${BUILD_DIR}/{dev,proc,sys,run}
mount_part() {
	mount -v --bind /dev ${BUILD_DIR}/dev
	mount -vt devpts devpts -o gid=5,mode=0620 ${BUILD_DIR}/dev/pts
	mount -vt proc proc ${BUILD_DIR}/proc
	mount -vt sysfs sysfs ${BUILD_DIR}/sys
	mount -vt tmpfs tmpfs ${BUILD_DIR}/run
}

exec_in_chroot() {
	chroot "${BUILD_DIR}" /usr/bin/env -i \
		HOME=/root	\
		TERM="$TERM"	\
		PATH=/usr/bin:/usr/sbin	\
		"$@"
}

if mountpoint -q ${BUILD_DIR}/dev; then
	:
else
	echo "[*] Mount the sys part to chroot"
	mount_part
fi

packages=$(cat ${READ_PATH}/packages/*.packages)

for pkg_list in "${packages[@]}"; do
	exec_in_chroot apt install -y $pkg_list
done

echo "[*] Cleaning chroot."

clean_dir=("
	"/var/lib/apt/lists/*"
	"/var/lib/cache/apt/*"
	")

for rdir in "${clean_dir[@]}"; do
	rm -rf $rdir
done
