FROM debian:stretch-slim

RUN apt-get update
RUN apt-get install -y nfs-kernel-server

COPY exports /etc/exports

EXPOSE 2049
EXPOSE 111

ADD run.sh /usr/local/bin/run.sh
RUN chmod u+x /usr/local/bin/run.sh
ENTRYPOINT ["run.sh"]
