FROM base:rocky
MAINTAINER botv96@gmail.com
LABEL Description="Workflow Services"


ARG PBR_VERSION=${PBR_VERSION:-"1.0.0"}
RUN apt update && \
    apt install -y git python-pip python python-setuptools crudini \
    python-dev libffi-dev libxslt1-dev libxml2-dev libyaml-dev libssl-dev \
    python-requests-oauthlib && \
    pip install PyMySQL 


# RUN git clone https://opendev.org/openstack/mistral.git /opt/mistral && \
#     cd /opt/mistral && \
#     pip install -e .

COPY mistral/requirements.txt /opt/
WORKDIR /opt
RUN pip install -r requirements.txt
COPY mistral /opt/mistral
WORKDIR /opt/mistral
RUN pip install -e .


COPY etc/. /etc/mistral/
COPY scripts/* /


WORKDIR /
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 8989
