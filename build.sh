#!/usr/bin/bash

set -e

# Work machine
CHECK_OS=$(grep ID_LIKE /etc/os-release | cut -b 9-)
READ_PATH=$(dirname "$0")
ASCII=$(cat "$READ_PATH/assets/ascii.txt")

# Default Build configuration
export CODENAME="sana"
DEBIAN_BRANCH="trixie"
DEBIAN_MIRROR="http://deb.debian.org/debian"
# Currently only support arm64 architectures
export ARCH=arm64
export BUILD_DIR="/opt/NetOpsy/build/$ARCH"
export NETHYDRA_MIRROR="http://repo.rstrike.my.id/$CODENAME/"
export BUILD_WITH_DESKTOP="false"
export NETHYDRA_MIRROR_KEYRING="joe-archive.key.gpg"

install_dep() {
	echo "Installing dependencies"
	apt install binfmt-support \
		debootstrap \
		tar \
		binutils \
		qemu-user-static
}

usage(){
	echo "Usage $0"
	exit 1
}

while [ "$#" -gt 0 ]; do
	case "$1" in
		--codename)
			[ -z "$2" ] && echo "Error: --codename requires value" && usage
			CODENAME="$2"
			shift 2
			;;
		--with-desktop)
			[ -z "$2" ] && echo "Error: --with-desktop usage" && usage
			case "$2" in
				true|false) BUILD_WITH_DESKTOP="$2" ;;
				*)
					echo  "Invalid options for '$2' (Use true or false value)"
					exit 1
					;;
			esac
			shift 2
			;;
		--build-dir)
			[ -z "$2" ] && echo "Error: please specify for --build-dir" && usage
			BUILD_DIR="$2"
			shift 2
			;;
		--help|-h)
			usage
			;;
		*)
			echo "Unkown options: $1"
			usage
			;;
	esac
done

if [[ ! $CHECK_OS == "debian" ]]; then
	echo "This script won't work for non debian based system."
	exit 1
else
	echo "${ASCII}"
	install_dep
fi

if [[ ! -e ${BUILD_DIR}/etc/os-release ]]; then
	mkdir -p ${BUILD_DIR}
	debootstrap --foreign --components main,contrib,non-free,non-free-firmware --arch ${ARCH} $DEBIAN_BRANCH ${BUILD_DIR} $DEBIAN_MIRROR
	. $READ_PATH/setup-base-fs.sh
	. $READ_PATH/helper/netopsy-build-system.sh
else
	read -p "Do you want to clean your current build? (y/n)" RESP
	if [ "$RESP" = "y" ]; then
		echo "Rebuilding NetOpsy"
		if mountpoint -q ${BUILD_DIR}/dev; then
			umount ${BUILD_DIR}/dev/pts
			umount ${BUILD_DIR}/dev
			umount ${BUILD_DIR}/proc
			umount ${BUILD_DIR}/sys
			umount ${BUILD_DIR}/run
		fi
		echo "Removing NetOpsy"
		rm -rfv ${BUILD_DIR}
		debootstrap --foreign --components main,contrib,non-free,non-free-firmware --arch ${ARCH} $DEBIAN_BRANCH ${BUILD_DIR} $DEBIAN_MIRROR
                . $READ_PATH/setup-base-fs.sh
                . $READ_PATH/helper/netopsy-build-system.sh
	else
		echo "Continue current build"
		# we will assume the partition has been mounted
		. $READ_PATH/setup-base-fs.sh
		. $READ_PATH/helper/netopsy-build-system.sh
	fi
fi

#mkdir -p ${BUILD_DIR}
#debootstrap --foreign --components main,contrib,non-free,non-free-firmware --arch ${ARCH} $DEBIAN_BRANCH ${BUILD_DIR} $DEBIAN_MIRROR
