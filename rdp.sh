#!/bin/bash

# PREREQUISITES:
# sudo apt install freerdp2-x11 moreutils
# nano ~/.env (Parameters see below)

# Set defaults
host=
user=
password=
resolution=1920x1080
bitdepth=16
logfile=~/rdplog.txt

# Overwrite defaults from .env file
source .env

# Read commandline flags:
#   -h HOST
#   -u USER
#   -l LOGFILE
while getopts h:u:l: flag
do
    case "${flag}" in
        h) host=${OPTARG};;
        u) user=${OPTARG};;
        p) password=${OPTARG};;
        l) logfile=${OPTARG};;
    esac
done

echo "******************************************"
echo "**            PI RDP CONNECT            **"
echo "******************************************"
echo

if [-z $host]
then
    echo    "Host       > "$host
else
    echo -n "Enter Host > "
    read host
fi

if [-z $user]
then
    echo    "User       > "$user
else
    echo -n "Enter User > "
    read user
fi

if [-z $user]
then
    echo    "Password   > ****"
else
    echo -n "Password   > "
    read -s password
fi

echo
echo
echo "-- INITIATING RDP SESSION FOR $user --" | ts '[%F %T]' | tee -a $logfile

xfreerdp /size:$resolution /bpp:$bitdepth /f /u:$user /p:$password /v:$host \
         /sound:sys:alsa,latency:100 /gdi:hw /network:broadband /cert-ignore \
         -clipboard +gfx-thin-client +auto-reconnect +fonts +multitouch \
         2>&1 | ts '[%F %T]' | tee -a $logfile

echo "-- ENDED RDP SESSION FOR $user --" | ts '[%F %T]' | tee -a $logfile
read -s
