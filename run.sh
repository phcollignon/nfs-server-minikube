kubectl delete -f examples/busybox-nfs-pvc-pv.yaml
kubectl delete -f examples/busybox-nfs.yaml
docker stop nfs-server
docker build -t phico/nfs-server docker-image
#docker push phico/nfs-server:latest
docker run -d --rm --privileged --name nfs-server  -v /var/nfs:/var/nfs  phico/nfs-server:latest
#docker run -d --rm --privileged --name nfs-server   --mount type=bind,source=/var/nfs,target=/var/nfs   phico/nfs-server:latest

docker network connect minikube nfs-server 

