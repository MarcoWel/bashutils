#!/bin/bash

echo "INSTALLING BASHTOOLS"
echo
echo "Note: To upgrade to a specific OS release:"
echo "      - sudo nano /etc/apt/sources.list"
echo "      - Modify version name (replace (e.g. strech with bullseye)"
echo "      - Save and close with STRG+X"
echo
echo -n "Should we perform a system update now (apt full-upgrade)? y/N "
read -n1 res
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
    echo "Creating empty .env file"
    cat > .env
host=
user=
password=
resolution=
bitdepth=
logfile=
<EOF>
fi

echo
echo "Done!"