FROM base:train
MAINTAINER tranbo9xnd@gmail.com

RUN apt update && \
    apt-get install -y glance-api python-memcache python3-rbd python3-rados


RUN mkdir /etc/ceph
COPY etc/ceph.conf /etc/ceph/ceph.conf
COPY etc/ceph.client.glance.keyring /etc/ceph/ceph.client.glance.keyring

COPY etc/glance-api.conf /etc/glance/glance-api.conf


COPY  scripts/* /


EXPOSE 9292
ENTRYPOINT ["./entrypoint.sh"]
