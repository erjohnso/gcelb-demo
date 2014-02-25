#!/bin/bash

# This script assumes that Debian-7 wheezy Compute Engine images are used
#
# Prior to using this install script, please execute
#   $ sudo apt-get update && sudo apt-get upgrade -y
#   $ sudo apt-get install git apache2 -y
#sudo DEBIAN_FRONTEND=noninteractive apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y >/dev/null 2>&1

pushd `dirname $0` > /dev/null
MY_PATH=`pwd`
popd > /dev/null

NAME=$(hostname -s)

echo "=> Copying HTML files, apache2.conf, enable mod-header, and restarting"
sudo cp $MY_PATH/index.html /var/www
sudo sed -i "s|@MY_INSTANCE_NAME@|$NAME|" /var/www/index.html
sudo chmod 644 /var/www/index.html
sudo cp $MY_PATH/apache2.conf /etc/apache2/apache2.conf
sudo ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load
sudo service apache2 restart

exit 0
