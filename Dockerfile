FROM alpine:3.11
ARG VER=1.15.2-31.1.27
WORKDIR /minecraft
RUN apk update && apk add openjdk8
#This file will have to be updated as forge versions are released
ADD https://files.minecraftforge.net/maven/net/minecraftforge/forge/$VER/forge-$VER-installer.jar /minecraft/installer.jar

RUN java -jar installer.jar --installServer \
    && echo "eula=true" > eula.txt \
    && chmod -R 777 /tmp \
    && mv forge-$VER.jar forge-server.jar
#VOLUME [/minecraft/world]
COPY . /minecraft

EXPOSE 25565

ENTRYPOINT ["java", "-Xmx2G", "-Xms1G", "-d64", "-jar", "forge-server.jar", "nogui"]
