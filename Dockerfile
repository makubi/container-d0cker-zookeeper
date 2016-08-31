FROM java:8

ENV ZOOKEEPER_VERSION=3.4.8

RUN wget https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz -O /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    wget https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc -O /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc && \
    wget https://www.apache.org/dist/zookeeper/KEYS -O /tmp/developers.gpg && \
    gpg --no-default-keyring --keyring zookeeper --import /tmp/developers.gpg && \
    gpgv --keyring zookeeper /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    tar -zx -C /opt -f /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    ln -s $(echo /opt/zookeeper-${ZOOKEEPER_VERSION}) /opt/zookeeper && \
    rm /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc /tmp/developers.gpg && \
    useradd -d $(echo /opt/zookeeper-${ZOOKEEPER_VERSION}) -s /bin/false zookeeper && \
    chown -R zookeeper $(echo /opt/zookeeper-${ZOOKEEPER_VERSION}) && \
    mkdir /var/lib/zookeeper && \
    chown zookeeper /var/lib/zookeeper

USER zookeeper
ADD zookeeper-entrypoint.sh /
WORKDIR /opt/zookeeper-${ZOOKEEPER_VERSION}

EXPOSE 2181
VOLUME ["/var/lib/zookeeper"]
ENTRYPOINT ["/zookeeper-entrypoint.sh"]
