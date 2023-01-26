#!/bin/bash

echo "INSTALLING BASHTOOLS"
echo

# Set defaults
host=
user=
password=
resolution=
bitdepth=
logfile=

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

read -n1 -p "Should we remove unneccessary packages? y/N " res
if [ $res == "y" ]
then
    echo "Removing packages..."
    echo
    wget https://raw.githubusercontent.com/MarcoWel/bashutils/master/cleanpi.sh -O - | sh
    echo
fi

uname -a
echo
read -n1 -p "Should we perform a kernel update now (rpi-update)? y/N " res
if [ $res == "y" ]
then
    echo "Performing kernel update..."
    echo
    sudo rpi-update
    echo
    uname -a
fi

echo "Note: To upgrade to a specific OS release:"
echo "      - sudo nano /etc/apt/sources.list"
echo "      - Modify version name (replace (e.g. strech with bullseye)"
echo "      - Save and close with STRG+X"
echo
read -n1 -p "Should we perform a system update now (apt full-upgrade)? y/N " res
if [ $res == "y" ]
then
    echo "Performing system update..."
    echo
    sudo apt update
    sudo apt -y full-upgrade
    sudo apt -y autoremove
    sudo apt -y autoclean
    echo
    lsb_release -a
fi

echo
echo "Installing prerequesites..."
echo

sudo apt install freerdp2-x11 moreutils

if [ ! -f .env ]
then
    echo
    echo "Creating default .env file"
    
    cat <<EOF > .env
host=$host
user=$user
password=$password
resolution=$resolution
bitdepth=$bitdepth
logfile=$logfile
EOF

fi

echo
echo "Creating desktop shortcuts"

cat <<EOF > ~/Desktop/Connect.desktop
[Desktop Entry]
Type=Application
Name=Connect
Type=Application
Path=/home/pi
Exec=bash ~/bashutils/rdp.sh
Terminal=true
Icon=system-users-symbolic
EOF

cat <<EOF > ~/Desktop/Connect with User.desktop
[Desktop Entry]
Type=Application
Name=Connect with User
Type=Application
Path=/home/pi
Exec=bash ~/bashutils/rdp.sh -u
Terminal=true
Icon=system-users-symbolic
EOF

echo
echo "Done!"