#!/bin/bash

set -exv

# init helpers
helpers_dir=${MONOPACKER_HELPERS_DIR:-"/etc/monopacker/scripts"}
for h in ${helpers_dir}/*.sh; do
    . $h;
done

# rebuild keyring
sudo apt update
sudo apt install -y build-essential libglib2.0-dev libgcrypt20-dev libpam0g-dev autoconf \
  automake libtool pkg-config curl pkg-config libgcr-3-dev libgck-1-dev xsltproc
cd /tmp
curl -o gnome-keyring.tar.xz https://download.gnome.org/sources/gnome-keyring/46/gnome-keyring-46.2.tar.xz
tar xvf gnome-keyring.tar.xz
cd gnome-keyring-46.2
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
./configure --prefix=/usr --sysconfdir=/etc --enable-pam --with-pam-dir=/lib/x86_64-linux-gnu/security --disable-doc
make -j2
make install
cd ~

echo "session optional        pam_gnome_keyring.so      use_authtok" >> /etc/pam.d/gdm-password
echo "password        optional        pam_gnome_keyring.so" >> /etc/pam.d/passwd
