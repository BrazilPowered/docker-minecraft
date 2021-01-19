FROM alpine:3.12
ARG VER=1.16.5-36.0.1
WORKDIR /minecraft

RUN apk update \
    && apk add openjdk8 screen \
########
# Bring in gettext so we can get `envsubst`, then throw
# the rest away. To do this, we need to install `gettext`
# then move `envsubst` out of the way so `gettext` can
# be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
#find dependencies to manually install
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/
########

#This file will have to be updated as forge versions are released
ADD https://files.minecraftforge.net/maven/net/minecraftforge/forge/$VER/forge-$VER-installer.jar /minecraft/installer.jar

RUN java -jar installer.jar --installServer \
    && echo "eula=true" > eula.txt \
    && chmod -R 777 /tmp \
    && mv forge-$VER.jar forge-server.jar \
    && touch server.properties
#VOLUME [/minecraft/world]
COPY . /minecraft


#env substituting
ENV spawnprotection=0
ENV levelseed=Brazil
ENV SERVPROPS='$spawnprotection:$levelseed'

# NOTE: start-mc script is comprised of these two lines in script form
#RUN envsubst "$SERVPROPS" < server.properties.starter > server.properties
#ENTRYPOINT ["screen", "-S", "minecraft", "java", "-Xmx2G", "-Xms1G", "-d64", "-jar", "forge-server.jar", "nogui"]
RUN chmod +x start-mc.sh
ENTRYPOINT . ./start-mc.sh

EXPOSE 25565
