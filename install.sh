#!/bin/bash

echo "INSTALLING BASHTOOLS"
echo

echo -n "Update system first (apt full-upgrade)? y/N "
read res
if [ $res == "y" ]
then
    echo "Performing system update..."
    echo
    sudo apt update
    sudo apt -y full-upgrade
    sudo apt -y autoremove
fi

echo
echo "Installing prerequesites..."
echo

sudo apt install freerdp2-x11 moreutils

cat > .env
host=
user=
password=
resolution=
bitdepth=
logfile=
<EOF>

echo
echo "Done!"