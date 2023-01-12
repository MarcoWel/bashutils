#!/bin/bash

echo "INSTALLING BASHTOOLS"
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