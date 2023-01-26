#!/bin/bash

# Usage:
# curl -s "https://raw.githubusercontent.com/MarcoWel/bashutils/master/install.sh" | bash -s -- -h "MYHOST" -u "MYUSER"

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
if [ -f ".env" ]
then
    source .env
fi

# Read commandline flags:
#   -h HOST
#   -u USER
#   -l LOGFILE
while getopts h:u:p:l: flag
do
    case "${flag}" in
        h) host=${OPTARG};;
        u) user=${OPTARG};;
        p) password=${OPTARG};;
        l) logfile=${OPTARG};;
    esac
done

echo "Host: $host"
echo "User: $user"

echo
read -n1 -p "Should we remove unneccessary packages? y/N " res
echo
if [ $res = "y" ]
then
    echo "Removing packages..."
    echo
    curl -s "https://raw.githubusercontent.com/MarcoWel/bashutils/master/cleanpi.sh" | bash
    echo
fi

echo
uname -a
echo
read -n1 -p "Should we perform a kernel update now (rpi-update)? y/N " res
echo
if [ $res = "y" ]
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
echo
if [ $res = "y" ]
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
echo "Installing packages..."
echo
sudo apt install raspberrypi-ui-mods freerdp2-x11 moreutils

if [ ! -d "$HOME/bashutils" ]
then
    mkdir "$HOME/bashutils"
fi

echo
echo "Downloading rdp.sh..."
echo
curl -s "https://raw.githubusercontent.com/MarcoWel/bashutils/master/rdp.sh" -o "$HOME/bashutils/rdp.sh"
chmod u+x "$HOME/bashutils/rdp.sh"

echo
echo "Creating .env file..."
cat <<EOF > "$HOME/bashutils/.env"
host=$host
user=$user
password=$password
resolution=$resolution
bitdepth=$bitdepth
logfile=$logfile
EOF
cat "$HOME/bashutils/.env"

echo
echo "Creating desktop shortcuts..."
cat <<EOF > "$HOME/Desktop/Connect.desktop"
[Desktop Entry]
Type=Application
Name=Connect
Type=Application
Path=~/bashutils
Exec=bash ~/bashutils/rdp.sh
Terminal=true
Icon=system-users-symbolic
EOF
chmod u+x "$HOME/Desktop/Connect.desktop"

cat <<EOF > "$HOME/Desktop/Connect with User.desktop"
[Desktop Entry]
Type=Application
Name=Connect with User
Type=Application
Path=~/bashutils
Exec=bash ~/bashutils/rdp.sh -u ""
Terminal=true
Icon=system-users-symbolic
EOF
chmod u+x "$HOME/Desktop/Connect with User.desktop"

echo
echo "Done!"