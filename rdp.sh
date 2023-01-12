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

if [ -z "$host" ]
then
    echo -n "Enter Host > "
    read host
else
    echo    "Host       > "$host
fi

if ping -c 1 $host &> /dev/null
then
  # Host is reachable, all good.
else
    if ping -c 1 8.8.8.8 &> /dev/null
    then
        echo "ERROR: Host not reachable! Internet seems okay. Please check network."
        exit 1
    else
        echo "ERROR: Host and internet not reachable! Please check internet connection."    
        exit 2
    fi
fi

if [ -z "$user" ]
then
    echo -n "Enter User > "
    read host
else
    echo    "User       > "$user
fi

if [ -z "$password" ]
then
    echo -n "Password   > "
    read -s password
else
    echo    "Password   > ****"
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
