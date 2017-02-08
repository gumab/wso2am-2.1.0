#!/bin/sh
 
manager_server_dir=~/wso2am-2.1.0/repository/deployment/server/
pem_file=~/.ssh/carbon-440.pem
 
 
#delete the lock on exit
trap 'rm -rf /var/lock/depsync-lock' EXIT
 
mkdir /tmp/carbon-rsync-logs/
 
 
#keep a lock to stop parallel runs
if mkdir /var/lock/depsync-lock; then
  echo "Locking succeeded" >&2
else
  echo "Lock failed - exit" >&2
  exit 1
fi
 
 
#get the workers-list.txt
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null
echo $SCRIPTPATH
 
 
for x in `cat ${SCRIPTPATH}/workers-list.txt`
do
echo ================================================== >> /tmp/carbon-rsync-logs/logs.txt;
echo Syncing $x;
rsync --delete -arve "ssh -i  $pem_file -o StrictHostKeyChecking=no" $manager_server_dir $x >> /tmp/carbon-rsync-logs/logs.txt
echo ================================================== >> /tmp/carbon-rsync-logs/logs.txt;
done