#!/bin/bash

# This is the packer install script and assumes a Debian-9 'stretch'
# base Compute Engine image is used.

ROOT=/var/www/html

echo "=> Installing apache2 package"
sudo DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y >/dev/null 2>&1

pushd `dirname $0` > /dev/null
MY_PATH=`pwd`
popd > /dev/null

echo "=> Copying HTML files, apache2.conf, enable mod-header, and restarting"
sudo cp $MY_PATH/index.html $ROOT
sudo chmod 644 $ROOT/index.html
sudo cp $MY_PATH/apache2.conf /etc/apache2/apache2.conf
sudo ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load
sudo systemctl restart apache2.service

exit 0
