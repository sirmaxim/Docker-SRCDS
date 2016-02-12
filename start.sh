#!/bin/bash
# SRCDS Container Start Script
#
# Copyright (c) 2016 Dane Everitt <dane@daneeveritt.com>
# MIT Licensed
# ##
set -x
if [ "$(pwd)" -ne "/home/container" ]; then
    cd /home/container
fi

# Download SteamCMD, it is missing
if [ ! -f "/home/container/steamcmd/steamcmd.sh" ]; then
    mkdir steamcmd; cd steamcmd
    curl -sS http://media.steampowered.com/installer/steamcmd_linux.tar.gz -o steamcmd.tar.gz
    if [ "$?" -ne "0" ]; then
        echo "There was an error while attempting to download SteamCMD (exit code: $?)"
        exit 1
    fi
    tar -xzvf steamcmd.tar.gz
    rm -rf steamcmd.tar.gz

    ./steamcmd.sh +login anonymous +force_install_dir /home/container +app_update $SRCDS_APPID +quit

    cd /home/container
    mkdir -p .steam/sdk32
    cp -v steamcmd/linux32/steamclient.so .steam/sdk32/steamclient.so
else
    echo "SteamCMD already exists on server, not downloading anything."
fi

cd /home/container

if [ -z "$STARTUP" ]; then
    echo "No startup command was specified."
    exit 1
fi

MODIFIED_STARTUP=`echo $STARTUP | perl -pe 's@{{(.*?)}}@$ENV{$1}@g'`
./srcds_run $MODIFIED_STARTUP

set +x
exit 0
