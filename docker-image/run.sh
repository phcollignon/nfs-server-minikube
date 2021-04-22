#!/bin/bash
  
function shutdown {
    echo "Stopping NFS server ..."
    service nfs-kernel-server stop
    echo "NFS server stopped"
    exit 0
}

trap "shutdown" SIGTERM

#echo "Configuring NFS v4 Only"
#echo "NEED_STATD=\"no\"" >> /etc/default/nfs-common
#echo "NEED_IDMAPD=\"yes\"" >> /etc/default/nfs-common
#echo "RPCNFSDOPTS=\"-N 2 -N 3\"" >> /etc/default/nfs-kernel-server
#echo "RPCMOUNTDOPTS=\"--manage-gids -N 2 -N 3\"" >> /etc/default/nfs-kernel-server

echo "Starting NFS server ..."
rpcbind -w
service nfs-kernel-server start
IP=`hostname -i`
echo "NFS server started and listening on $IP"

sleep infinity & wait

