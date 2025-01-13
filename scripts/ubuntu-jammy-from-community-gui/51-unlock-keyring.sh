#!/bin/bash

set -exv

# init helpers
helpers_dir=${MONOPACKER_HELPERS_DIR:-"/etc/monopacker/scripts"}
for h in ${helpers_dir}/*.sh; do
    . $h;
done

# rebuild keyring
apt install -y curl pkg-config
cd /tmp
curl -o gnome-keyring.tar.xz https://download.gnome.org/sources/gnome-keyring/46/gnome-keyring-46.2.tar.xz
tar xvf gnome-keyring.tar.xz
./configure --prefix=/usr --sysconfdir=/etc --enable-pam --with-pam-dir=/lib/x86_64-linux-gnu/security
make
make install
cd -

echo "session optional        pam_gnome_keyring.so      use_authtok" >> /etc/pam.d/gdm-password
echo "password        optional        pam_gnome_keyring.so" >> /etc/pam.d/passwd
