#!/bin/bash

# Usage:
# bash <(curl -s "https://raw.githubusercontent.com/MarcoWel/bashutils/master/install.sh") -h "MYHOST" -u "MYUSER"

echo "INSTALLING BASHUTILS"
echo

# Set defaults
host=
user=
password=
resolution="1920x1080"
bitdepth="16"
logfile="$HOME/rdplog.txt"

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

if [[ -d "$HOME/bashutils" ]]
then
    echo
    echo "Removing old bashutils..."
    rm -rf "$HOME/bashutils"
fi

echo
echo "Downloading repo..."
echo
git clone "https://github.com/MarcoWel/bashutils.git" "$HOME/bashutils"
#curl -s "https://raw.githubusercontent.com/MarcoWel/bashutils/master/rdp.sh" -o "$HOME/bashutils/rdp.sh"
#chmod u+x "$HOME/bashutils/rdp.sh"

echo
echo "Creating rdp.env file..."
cat <<EOF > "$HOME/rdp.env"
host=$host
user=$user
password=$password
resolution=$resolution
bitdepth=$bitdepth
logfile=$logfile
EOF

echo
echo "Creating desktop shortcuts..."
cat <<EOF > "$HOME/Desktop/Connect.desktop"
[Desktop Entry]
Type=Application
Name=Connect
Type=Application
Exec=bash bashutils/rdp.sh
Terminal=true
Icon=system-users-symbolic
EOF
chmod u+x "$HOME/Desktop/Connect.desktop"

cat <<EOF > "$HOME/Desktop/Connect with User.desktop"
[Desktop Entry]
Type=Application
Name=Connect with User
Type=Application
Exec=bash bashutils/rdp.sh -u ""
Terminal=true
Icon=system-users-symbolic
EOF
chmod u+x "$HOME/Desktop/Connect with User.desktop"

echo
echo "Installing packages..."
echo
sudo apt install raspberrypi-ui-mods freerdp2-x11 moreutils

echo
echo
echo "*** Bashutils installation is complete! ***"
echo
read -p "Would you like to perform a system update as well? y/N " res
if [[ $res == "y" ]]
then
    echo
    read -p ">> Remove unneccessary packages to free disk space? y/N " res
    if [[ $res == "y" ]]
    then
        echo "Removing packages..."
        echo
        $HOME/bashutils/cleanpi.sh
        echo
    fi

    echo
    echo "Current kernel version:"
    uname -a
    echo
    read -p ">> Perform a kernel update now (rpi-update)? y/N " res
    if [[ $res == "y" ]]
    then
        echo "Performing kernel update..."
        echo
        sudo rpi-update
        echo
        uname -a
    fi

    echo
    echo "Current OS version:"
    lsb_release -a
    echo
    echo "Note: To upgrade to a specific OS release:"
    echo "      - Check  /etc/apt/sources.list  and files in  /etc/apt/sources.list.d/"
    echo "      - Open in editor (e.g. sudo nano) and replace OS version (e.g. strech with bullseye)"
    echo
    read -p ">> Perform a system update now (apt update && apt full-upgrade)? y/N " res
    if [[ $res == "y" ]]
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
    echo "Done!"
fi