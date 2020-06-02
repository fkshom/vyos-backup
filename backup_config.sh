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
SCRIPTPATH=$(readlink -f $0)
SCRIPTDIR=$(cd $(dirname $SCRIPTPATH); pwd)

source $SCRIPTDIR/config
REPOSITORYDIR=-/home/vyos/backup
HOSTNAME=-`hostname`
GIT_USERNAME=-vyos
GIT_USEREMAIL=-vyos@example.com

now=`date "+%Y/%m/%d %H:%M:%S"`
GITOPT="-c user.name='$GIT_USERNAME' -c user.email='GIT_USEREMAIL'"

#Backup Git
cd $REPOSITORYDIR

if git show-ref --quiet refs/remotes/origin/$HOSTNAME; then
  git checkout $HOSTNAME
else
  git checkout -B $HOSTNAME
fi

rsync -a --delete --exclude=archive/ --exclude=vyos-migrate.log --exclude=vyos-config-backup $SRCDIR/ $REPOSITORYDIR/config/

git add .
git $GITOPT commit -m "$HOSTNAME backup config $now"

if [ $PUSH -eq 1 ]; then
  git push -u origin $HOSTNAME
fi

echo "Backup completed"
