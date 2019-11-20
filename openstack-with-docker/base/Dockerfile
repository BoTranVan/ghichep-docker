FROM ubuntu:18.04


# Add OpenStack repository
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y cloud-archive:train

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

RUN ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Install crudini for run entrypoint
RUN apt install -y vim crudini
