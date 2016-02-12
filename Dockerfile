##
# Minimalist Docker Container for SRCDS
# Built for Pterodactyl Panel
#
# MIT Licensed
##
FROM ubuntu:15.10

MAINTAINER  Dane Everitt, <dane@daneeveritt.com>
ENV         DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN         apt-get update
RUN         apt-get install -y tar curl gcc g++ lib32gcc1 lib32tinfo5 lib32z1 lib32stdc++6

RUN         useradd -m -d /home/container container

USER        container
ENV         HOME /home/container

WORKDIR     /home/container

COPY        ./start.sh /start.sh

CMD         ["/bin/bash", "./start.sh"]
