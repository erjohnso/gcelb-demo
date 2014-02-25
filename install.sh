#!/bin/bash

# This script assumes that Debian-7 wheezy Compute Engine images are used
# and that the user has already installed the apache2 package
#
# Prior to using this install script, please execute
#   $ sudo apt-get update && sudo apt-get upgrade -y
#   $ sudo apt-get install git apache2 -y

pushd `dirname $0` > /dev/null
MY_PATH=`pwd`
popd > /dev/null

NAME=$(hostname -s)

echo "=> Copying HTML files, apache2.conf, and restarting service..."
sudo cp $MY_PATH/demo.css /var/www
sudo cp $MY_PATH/index.html /var/www
sudo sed -i "s|@MY_INSTANCE_NAME@|$NAME|" /var/www/index.html
sudo chmod 644 /var/www/*
sudo cp $MY_PATH/apache2.conf /etc/apache2/apache2.conf
sudo service apache2 restart

exit 0
