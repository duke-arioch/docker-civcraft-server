FROM docker-spigot-builder:1.12.2 as BUILD

FROM openjdk:10-jre-slim
LABEL maintainer="Duke Arioch <darien.arioch@gmail.com>"

WORKDIR /opt/spigot/

COPY --from=BUILD /src/build/spigot/spigot-1.12.2.jar /opt/spigot/lib/spigot-1.12.2.jar

#install mariadb
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y apt-utils && apt-get upgrade -y && apt-get install dos2unix
RUN apt-get install -y mariadb-server


#VOLUME ["/opt/spigot/", "/srv/spigot/plugins/"]
COPY build/resources/plugins/ /opt/spigot/plugins/
COPY build/resources/main/plugins/ /opt/spigot/plugins/

COPY build/resources/main/scripts/docker-entrypoint.sh /opt/spigot
RUN dos2unix -k /opt/spigot/docker-entrypoint.sh
RUN chmod +x /opt/spigot/docker-entrypoint.sh

COPY build/resources/main/scripts/create-db.sh /opt/spigot
RUN dos2unix -k /opt/spigot/create-db.sh
RUN /opt/spigot/create-db.sh

COPY build/resources/main/server-icon.png /opt/spigot

EXPOSE 3306

# Work path
# Copy of the MySQL startup script
#COPY scripts/start.sh start.sh

# Create the persistent volume
VOLUME [ "/var/lib/mysql" ]
VOLUME ["/opt/spigot/plugins"]
EXPOSE 25565

ENTRYPOINT /opt/spigot/docker-entrypoint.sh
