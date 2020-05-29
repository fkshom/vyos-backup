#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

#Environment
SCRIPTDIR=$(cd $(dirname $0); pwd)
SRCDIR=/config
BACKUPDIR=./
HOSTNAME=`hostname`
now=`date "+%Y/%m/%d %H:%M:%S"`
GITOPT="-c user.name='vyos' -c user.email='vyos@example.com'"

#Backup Git
#cd $SCRIPTDIR
cd $BACKUPDIR

if git show-ref --quiet refs/remote/origin/$HOSTNAME; then
  git checkout $HOSTNAME
else
  git checkout -B $HOSTNAME
fi

rsync -a --delete --exclude=archive/ --exclude=vyos-migrate.log $SRCDIR/ $BACKUPDIR/config/

git add .
git $GITOPT commit -m "$HOSTNAME backup config $now"

#git push -u origin $HOSTNAME
