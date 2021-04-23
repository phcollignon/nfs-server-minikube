#!/bin/bash
  
function shutdown {
    echo "Stopping NFS server ..."
    service nfs-kernel-server stop
    echo "NFS server stopped"
    exit 0
}

trap "shutdown" SIGTERM

mkdir -p /var/nfs/exports
chmod 777 /var/nfs/exports

#echo "Configuring NFS v4 Only"
#echo "NEED_STATD=\"no\"" >> /etc/default/nfs-common
#echo "NEED_IDMAPD=\"yes\"" >> /etc/default/nfs-common
#echo "RPCNFSDOPTS=\"-N 2 -N 3\"" >> /etc/default/nfs-kernel-server
#echo "RPCMOUNTDOPTS=\"--manage-gids -N 2 -N 3\"" >> /etc/default/nfs-kernel-server
#systemctl mask rpcbind.service
#systemctl mask rpcbind.socket
#systemctl stop rpc-gssd.service

echo "Starting NFS server ..."
rpcbind 
service nfs-kernel-server start
IP=`hostname -i`
echo "NFS server started and listening on $IP"

sleep infinity & wait

