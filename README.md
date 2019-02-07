# docker-civ-server
This project creates a functioning Civcraft-style Minecraft server image that can be used to test new configurations quickly easily. 

It includes:
 
 * a folder for customized plugin yaml configurations.
 * gradle build for specifying and pulling any needed plugins
 * a docker file including Java, MariaDB setup and configured Spigot runtime 

This is not a fork of [Kawaii Spigot Server](https://github.com/kawaii/docker-spigot-server) but was heavily influenced by it.

I used [Kawaii Spigot builder](https://github.com/kawaii/docker-spigot-builder) image for setup of build tool artifacts as visible in the Dockerfile. I ran this at 1.12.2 since this is what most current civ servers run at. This means we don't have to carry the build tools around in the runtime image, saving space.

## Prerequisites

* Docker installation
* Kawaii Spigot Builder for 1.12.2. To build the builder, follow directions at [Kawaii Spigot builder](https://github.com/kawaii/docker-spigot-builder) and make sure you have the right build tools version for your needs.

## Usage

When you build the builder image, tag it as ```docker-spigot-builder:1.12.2```to make it usable by the subsequent commands. 
 
To build an image named civ at version 1.12.2, use
```
gradle clean build
docker build . -t civ:1.12.2
```

To run the created image, use 

```
docker container run -p 25565:25565 -e SPIGOT_AGREE_EULA=true civ:1.12.2
```

Please beware that due to Namelayer oddities, the server will not successfully stay up on the first run. When it stops, please just get the Docker process for the stopped container and restart it. 

## Miscellaneous information

A few file contents bear some small bit of extra explanation.

|Dockerfile Details ||
|---|---|
| ```FROM```   | Container is primarily built on the openjdk jre 10 slim image (openjdk:10-jre-slim. Change this if you need to.)
| ```VOLUME```   | Container keeps persistent database and plugin config data in these between starts|
| ```dos2unix``` | For anyone else who builds containers on a Windows laptop |

|Important Files/folders||
|---|---|
| ```src/main/resources/plugins``` | contains all plugin configs that should be externalized.|
| ```src/main/scripts``` | contains all build and run scripts|
| ```create-db.sh``` | run at build time to ensure databases and users are created appropriately. If you need other databases or users place them here.|
| ```docker-entrypoint.sh``` | run when the container starts. It starts the database, waits for it to finish coming up, creates ```server.properties``` if needed and then begins the Spigot server process. |

## More Thoughts/Uses/To-Do's

### Building

Civcraft plugin projects are notorious for their many forks and poorly maintained binary repos. One exception to this is the excellent [DevotedMC](https://build.devotedmc.com) build server and plugin repo. 

I hope that civ plugin projects will eventually move to a consistent hosted CI and use github releases as their storage mechanism. This would be a boon to many aspiring contributors.   

### Pre-generated Worlds and Storage
Volume mounts have been added for map data - to start each container with a fresh world-edited map. Currently lets world be created (or picked up from host system) each time the container is created.

Map import, export has not been handled here as this is a testing tool primarily, but could be added pretty easily by specifying volume mounts on local machine or using other techniques.

### Production Server Use

While primarily for testing purposes, depending on performance, it might be possible to use in a production setting, though stress testing would be needed. At that point, it might be desireable to split MariaDB out to separate container, though other Civcraft servers deploy them together.  

This image can be automated with Kubernetes to spin up countless worlds with the same basic consistent set of plugin configurations. Think of Civcraft-style MC-Realms Servers on demand.

