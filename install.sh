#!/usr/bin/env bash

CODENAME=`cat /etc/os-release  | grep VERSION_CODENAME | cut -d= -f2`

mkdir -p /config/user-data/etc/apt

cat <<EOF > /config/user-data/etc/apt/sources.list
deb http://deb.debian.org/${CODENAME}/ buster main
deb http://security.debian.org/ ${CODENAME}/updates main
EOF

sed -i -e '/#CUSTOM01/d' /config/scripts/vyos-postconfig-bootup.script
cat <<EOF >> /config/scripts/vyos-postconfig-bootup.script 
ln -sf /config/user-data/etc/apt/sources.list /etc/apt/sources.list  #CUSTOM01
EOF
