#!/usr/bin/env bash

# set apt  sources.list
#=================================
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

# install backup_conifig.sh
#=================================
INSTALLDIR=/config/vyos-config-backup
mkdir $INSTALLDIR

curl https://raw.githubusercontent.com/fkshom/vyos-config-backup/master/backup_config.sh > $INSTALLDIR/backup_config.sh
chmod a+x $INSTALLDIR/backup_config.sh
ln -sf $INSTALLDIR/backup_config.sh /usr/local/bin/backup_config.sh

echo "installed backup_config.sh on /usr/local/bin/backup_config.sh"

