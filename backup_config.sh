#!/bin/vbash

function usage() {
  echo "USAGE: $0 [-p]"
  echo "-p: push after commit"
  exit
}

PUSH=0
while getopts ph OPT; do
  case $OPT in
    "p" ) PUSH=1 ;;
    "h" ) usage ;;
  esac
done

#source /opt/vyatta/etc/functions/script-template

#Environment
SCRIPTDIR=$(cd $(dirname $0); pwd)
SRCDIR=/config
DSTDIR=./
HOSTNAME=`hostname`
now=`date "+%Y/%m/%d %H:%M:%S"`
GITOPT="-c user.name='vyos' -c user.email='vyos@example.com'"

#Backup Git
cd $DSTDIR

if git show-ref --quiet refs/remote/origin/$HOSTNAME; then
  git checkout $HOSTNAME
else
  git checkout -B $HOSTNAME
fi

rsync -a --delete --exclude=archive/ --exclude=vyos-migrate.log $SRCDIR/ $DSTDIR/config/

git add .
git $GITOPT commit -m "$HOSTNAME backup config $now"

if [ $PUSH -eq 1 ]; then
  git push -u origin $HOSTNAME
fi

echo "Backup completed"
