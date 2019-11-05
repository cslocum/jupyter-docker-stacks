#!/bin/bash
set -eux

env

VNC_APPLICATION_DIR=$CONDA_DIR/vnc
mkdir $VNC_APPLICATION_DIR
pushd $VNC_APPLICATION_DIR

# Novnc: just want web files
curl -sSfL https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -zxf -


# Install tigervnc
curl -sSfL 'https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.9.0.x86_64.tar.gz' | tar -zxf - --strip=2

# Patch novnc to use correct path to websockify (defaults to /)
# Note if you use vnc.html you will need to patch ui.js to use the correct path
# and also to override localstorage which may store an incorrect path from a
# different session
# Also resize server instead of scaling client
sed -i.bak \
    -e "s%\('path', 'websockify'\)%'path', window.location.pathname.replace(/[^/]*$/, '').substring(1) + 'websockify'); console.log('websockify path:' + path%" \
    -re "s%rfb.scaleViewport = .+%rfb.resizeSession = readQueryVariable('resize', true);%" \
    noVNC-1.1.0/vnc_lite.html


pip install /opt/jupyter_desktop
