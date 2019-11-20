FROM base:train
MAINTAINER tranbo9xnd@gmail.com

# Install keystone
RUN apt-get update && \
    apt-get install -y libapache2-mod-wsgi-py3 keystone apache2

COPY ./etc/keystone.conf /etc/keystone/keystone.conf
COPY ./scripts/* /

WORKDIR /
EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]