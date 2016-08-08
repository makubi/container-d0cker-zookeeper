FROM java:8

ENV ZOOKEEPER_VERSION=3.4.5

ENV ZOOKEEPER_ARCHIVE=zookeeper-${ZOOKEEPER_VERSION}.tar.gz
ENV ZOOKEEPER_ARCHIVE_ASC=${ZOOKEEPER_ARCHIVE}.asc

ENV ZOOKEEPER_WORKDIR=/opt/zookeeper-${ZOOKEEPER_VERSION}

ADD https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_ARCHIVE} /tmp/
ADD https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_ARCHIVE_ASC} /tmp/

ADD https://www.apache.org/dist/zookeeper/KEYS /tmp/developers.gpg

RUN gpg --import /tmp/developers.gpg && \
    gpg --verify /tmp/$ZOOKEEPER_ARCHIVE_ASC /tmp/$ZOOKEEPER_ARCHIVE && \
    tar -zx -C /opt -f /tmp/$ZOOKEEPER_ARCHIVE && \
    rm /tmp/$ZOOKEEPER_ARCHIVE /tmp/$ZOOKEEPER_ARCHIVE_ASC /tmp/developers.gpg

RUN useradd -d $(echo $ZOOKEEPER_WORKDIR) -s /bin/false zookeeper && \
    chown -R zookeeper $(echo $ZOOKEEPER_WORKDIR) && \
    mkdir /var/lib/zookeeper && \
    chown zookeeper /var/lib/zookeeper

USER zookeeper
ADD zookeeper-entrypoint.sh /

EXPOSE 2181
VOLUME ["/var/lib/zookeeper"]
ENTRYPOINT ["/zookeeper-entrypoint.sh"]
