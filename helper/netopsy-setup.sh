#!/usr/bin/env bash

set -e

vncserver_setup() {
        mkdir -p ${BUILD_DIR}/etc/skel/.vnc
        cat <<EOF > ${BUILD_DIR}/etc/skel/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
        chmod +x ${BUILD_DIR}/etc/skel.vnc/xstartup
}
