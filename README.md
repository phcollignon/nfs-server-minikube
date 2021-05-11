# NFS Server for Kubernetes (minikube)

Here is a minimalist NFS server for testing NFS Storage with Kubernetes (minikube)

Please note that this is only for testing, development and educational purposes.  

It has been developped for the course "Deploying Statefull Application to Kubernetes" @PluralSight.

## Environment
The environment consists in : 
- minikube running in Docker
- NFS server running in Docker in the minikube network
- Dynamic NFS Storage Provisioner (from [nfs-subdir-external-provisioner/deploy](nfs-subdir-external-provisioner/deploy))
- CSI NFS Driver (from [https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner))

![](env.png)

## How to deploy
1. First, install [Docker](https://docs.docker.com/) (version 18.09.1 or higher) if it is not already available on your platform
2. Download and run [minikube](https://minikube.sigs.k8s.io/docs/) with docker driver 
```
minikube start
```
2. Run NFS server in Docker :
```
docker run -d --rm --privileged --name nfs-server  -v /var/nfs:/var/nfs  phico/nfs-server:latest
 ``` 
 By default, the NFS share is mounted with a volume in a `/var/nfs` directory on your host.

 3. Add the `nfs-server` container to minikube docker network :
``` 
docker network connect minikube nfs-server 
```
4. Install Kubectl [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/)
5. [Optional] Install NFS dynamic provisioner from [nfs-subdir-external-provisioner/deploy](nfs-subdir-external-provisioner/deploy) directory : 
```
kubectl apply -f rbac.yaml
kubectl apply -f deployment.yaml
kubectl apply -f storageClass.yaml
``` 

Credit to project : [https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner).  

6. [Optional] Install NFS CSI Driver from [csi-driver-nfs/deploy](csi-driver-nfs/deploy)  directory :

```
kubectl apply -f rbac-csi-nfs-controller.yaml
kubectl apply -f csi-nfs-driverinfo.yaml
kubectl apply -f csi-nfs-controller.yaml
kubectl apply -f csi-nfs-node.yaml
```
Credit to project : [https://github.com/kubernetes-csi/csi-driver-nfs](https://github.com/kubernetes-csi/csi-driver-nfs). 



## How to use
Please check the [examples](examples) folder for following usages :
|                    |                         |
| ------------------ | --------------------|
| [busybox-nfs.yaml](examples/busybox-nfs.yaml)      | Volume in a pod |
| [busybox-nfs-pvc-pv.yaml](examples/busybox-nfs-pvc-pv.yaml)      |    Volume in a PersistentVolume with PersistentVolumeClaim |
| [busybox-nfs-pvc-pv-sc.yaml](examples/busybox-nfs-pvc-pv-sc.yaml) |    Volume in a PersistentVolume with StorageClass and dynamic provisioning : (Please note that you first have to install NFS dynamic provisioner as noted above)  |
| [busybox-nfs-pvc-pv-csi.yaml](examples/busybox-nfs-pvc-pv-csi.yaml) |    Volume in a PersistentVolume with StorageClass and dynamic provisioning based on CSI NFS driver : (Please note that you first have to install CSI NFS driver as noted above)  |

Sample usage :
```
kubectl apply -f busybox-nfs-pvc-pv.yaml
kubectl delete -f busybox-nfs-pvc-pv.yaml
```
Then list the `/var/nfs/exports` folder content to view the nfs server storage content.

i.e. :
```
cat /var/nfs/exports/log.txt
```
should show the `busybox-nfs` example output


## Additional configuration for the "Deploying Statefull Application to Kubernetes" course @PluralSight.

Add ingress support so that the users can access the demo application.

Finally, we’ll add the ingress support to minikube to access the demo. 
``` 
minikube addons enable ingress
``` 
(WARNING : minikube 19.0 ingress support is bugged [https://github.com/kubernetes/minikube/issues/11121](https://github.com/kubernetes/minikube/issues/11121))

And we configure the name resolution so that the user can access the application with a domain name
 by first getting the node’s IP with :
 ```
 minikube ip
 ```
and then, resolving the two domain names to that IP in the host’s file one for the frontend and one for the backend API.
/etc/hosts
```
127.0.0.1	localhost
127.0.1.1	cursus
192.168.49.2 guestbook.frontend.minikube.local
192.168.49.2 guestbook.backend.minikube.local

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Alternatively you can use the `minikube ingress-dns` addon and resolve only the minikube ip in the hosts file.


## How to build 

The prebuilt image is pushed on Docker Hub in this repository : [https://hub.docker.com/repository/docker/phico/nfs-server](https://hub.docker.com/repository/docker/phico/nfs-server)

If you want to modify the NFS server, the docker image source code is in [docker-image](docker-image) folder.
