#!/bin/bash

# PREREQUISITES:
# sudo apt install freerdp2-x11 moreutils
# nano ~/.env (Parameters see below)

# Set defaults
host=
domain=
user=
password=
resolution="1920x1080"
bitdepth="16"
logfile="$HOME/rdplog.txt"

# Overwrite defaults from .env file
if [ -f "$HOME/rdp.env" ]
then
    source "$HOME/rdp.env"
fi

# Read commandline flags:
#   -h HOST
#   -d DOMAIN
#   -u USER
#   -l LOGFILE
while getopts h:d:u:p:l: flag
do
    case "${flag}" in
        h) host=${OPTARG};;
        d) domain=${OPTARG};;
        u) user=${OPTARG};;
        p) password=${OPTARG};;
        l) logfile=${OPTARG};;
    esac
done

echo
echo "******************************************"
echo "**            PI RDP CONNECT            **"
echo "******************************************"
echo

if [ -z "$host" ]
then
    echo -n "Enter Host > "
    read host
else
    echo -n "Host       > "$host
fi

if ping -c 1 $host &> /dev/null
then
    echo " ... reachable"
else
    if ping -c 1 8.8.8.8 &> /dev/null
    then
        echo "ERROR: Host $host not reachable! Internet seems okay. Please check host address and network."
        exit 1
    else
        echo "ERROR: Host $host and internet not reachable! Please check internet connection."    
        exit 2
    fi
fi

if [ -z "$domain" ]
then
    echo -n "Enter Domain > "
    read host
else
    echo    "Domain     > "$domain
fi

if [ -z "$user" ]
then
    echo -n "Enter User > "
    read user
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
set -o pipefail

xfreerdp /size:"$resolution" /bpp:"$bitdepth" /f /u:"$user" /d:"$domain" /p:"$password" /v:"$host" \
         /sound:sys:alsa,latency:100 /gdi:hw /network:broadband /cert-ignore \
         -clipboard +gfx-thin-client +auto-reconnect +fonts +multitouch \
         2>&1 | grep -v 'recursive lock from' | ts '[%F %T]' | tee -a $logfile

freerdp_exitcode=$?

echo "-- ENDED RDP SESSION FOR $user --" | ts '[%F %T]' | tee -a $logfile

if [ $freerdp_exitcode -gt 2 ]
then
    # Wait for user input
    read -s
fi
