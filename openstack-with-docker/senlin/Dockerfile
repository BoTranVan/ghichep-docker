FROM base:train
MAINTAINER botv96@gmail.com
LABEL Description="Clustering Services"


ARG PBR_VERSION=${PBR_VERSION:-"1.0.0"}
RUN apt update && \
    apt install -y git python-pip python python-setuptools crudini && \
    pip install PyMySQL python-memcached

RUN git clone https://git.openstack.org/openstack/senlin.git /opt/senlin && \
    cd /opt/senlin && \
    pip install -e .

COPY senlin /opt/senlin
WORKDIR /opt/senlin
RUN pip install -e .

COPY etc/. /etc/senlin/
COPY scripts/* /

WORKDIR /
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 8777
