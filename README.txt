Simple project to make a simple baseline forge server for minecraft
run with port 25565 exposed and one of these options:

1) Add your world to a docker volume (located at ${PWD}), and attach it to your world
  docker volume create --driver local -o o=bind -o type=none -o device="${PWD}" mcworld

  docker container run -itp 25565:25565 --rm --name mc -v mcworld:/minecraft/world brazil/minecraft:1.16.3-forge

2) No-pain fresh start with a new random world:
  docker container run -dp 25565:25565 --rm --name mc brazil/minecraft:$ver


Included files are:
README.txt                 - This document, to inform
Dockerfile                 - used to build the docker image
./config/*                 - configure forge config in a docker image build
./world/*                  - These files should all be copied into any world directory you will use with this image; or sets configurations in advance for your new world
server.properties.starter  - Configuration for forge server in a docker image build for its initial startup; avoids warnings & allows customization.
                           --NOTE: This not the server.properties file, but will be used to create it. This file will be overwritten for substitution of key elements && then copied into a fresh server.properties file.

TODO:
Add documentation to show how to start maps with anythiong OTHER than the "Brazil" seed.
Add options to edit other servier properties on startup using env file (server.properties.starter) and script.

NOTE:
The following Warnings may pop up on start; these typically are only if NO WORLD VOLUME is attached when starting the container (option 2 above)

[04:30:43] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, destination] and [teleport, targets] with inputs: [Player, 0123, @e, dd12be42-52a9-4a91-a8a1-11c01849e498]
[04:30:43] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, location] and [teleport, destination] with inputs: [0.1 -0.5 .9, 0 0 0]
[04:30:43] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, location] and [teleport, targets] with inputs: [0.1 -0.5 .9, 0 0 0]
[04:30:43] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, targets] and [teleport, destination] with inputs: [Player, 0123, dd12be42-52a9-4a91-a8a1-11c01849e498]
[04:30:43] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, targets, location] and [teleport, targets, destination] with inputs: [0.1 -0.5 .9, 0 0 0]
...
[04:30:53] [Server thread/WARN] [minecraft/ServerWorld]: Unable to find spawn biome


Reconnect to console:
docker exec into the running container, then execute the following to access the server console running in the active screen session:
screen -xS minecraft

You can exit the screen session and stay in the container with Ctrl-a, then d OR by simply leaving your exec session





World icon is by blagoicons