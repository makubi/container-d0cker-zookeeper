FROM java:8

ENV ZOOKEEPER_VERSION=3.4.8

ENV ZOOKEEPER_ARCHIVE=zookeeper-${ZOOKEEPER_VERSION}.tar.gz
ENV ZOOKEEPER_ARCHIVE_ASC=${ZOOKEEPER_ARCHIVE}.asc

ENV ZOOKEEPER_WORKDIR=/opt/zookeeper-${ZOOKEEPER_VERSION}

RUN wget https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_ARCHIVE} -O /tmp/${ZOOKEEPER_ARCHIVE} && \
    wget https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_ARCHIVE_ASC} -O /tmp/${ZOOKEEPER_ARCHIVE_ASC} && \
    wget https://www.apache.org/dist/zookeeper/KEYS -O /tmp/developers.gpg && \
    gpg --no-default-keyring --keyring zookeeper --import /tmp/developers.gpg && \
    gpg --no-default-keyring --keyring zookeeper --export > /tmp/gpg-zookeeper.bin && \
    gpgv --keyring zookeeper /tmp/$ZOOKEEPER_ARCHIVE_ASC /tmp/$ZOOKEEPER_ARCHIVE && \
    tar -zx -C /opt -f /tmp/$ZOOKEEPER_ARCHIVE && \
    rm /tmp/$ZOOKEEPER_ARCHIVE /tmp/$ZOOKEEPER_ARCHIVE_ASC /tmp/developers.gpg /tmp/gpg-zookeeper.bin && \
    useradd -d $(echo $ZOOKEEPER_WORKDIR) -s /bin/false zookeeper && \
    chown -R zookeeper $(echo $ZOOKEEPER_WORKDIR) && \
    mkdir /var/lib/zookeeper && \
    chown zookeeper /var/lib/zookeeper

USER zookeeper
ADD zookeeper-entrypoint.sh /
WORKDIR ${ZOOKEEPER_WORKDIR}

EXPOSE 2181
VOLUME ["/var/lib/zookeeper"]
ENTRYPOINT ["/zookeeper-entrypoint.sh"]
