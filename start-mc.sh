#!/bin/sh
envsubst "$SERVPROPS" < server.properties.starter > server.properties
screen -S minecraft java -Xmx2G -Xms1G -d64 -jar forge-server.jar nogui
