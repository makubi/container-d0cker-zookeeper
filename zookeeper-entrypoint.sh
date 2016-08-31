#!/bin/bash

set -e

ZOOKEEPER_WORKDIR="/opt/zookeeper"

if [ -z "$TICK_TIME" ] || [ -z "$CLIENT_PORT" ]; then
	echo "Please set TICK_TIME and CLIENT_PORT env"
	exit 1
fi

ZOO_CFG="$ZOOKEEPER_WORKDIR/conf/zoo.cfg"

echo "tickTime=$TICK_TIME" >> $ZOO_CFG
echo "dataDir=/var/lib/zookeeper" >> $ZOO_CFG
echo "clientPort=$CLIENT_PORT" >> $ZOO_CFG

"$ZOOKEEPER_WORKDIR/bin/zkServer.sh" start-foreground
