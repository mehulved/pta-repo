#!/bin/bash

# Version of the app
PYTHON_APP_VERSION=0.2

# User that the app runs as
PYTHON_APP_USER=pyuser

# Location of the Python App
PYTHON_APP_DIR=/opt/hello-python

# Ensure the python app user and home directory exists
getent passwd $PYTHON_APP_USER > /dev/null
if [[ $? -ne 0 ]]
then
    sudo useradd -M -s /bin/bash $PYTHON_APP_USER 
    if [[ $? -eq 0 ]]
    then
        echo "$PYTHON_APP_USER created."
    fi
fi
if [[ ! -d $PYTHON_APP_DIR ]]
then
    sudo mkdir $PYTHON_APP_DIR
    if [[ $? -eq 0 ]]
    then 
        echo "$PYTHON_APP_DIR created"
    fi
    sudo chown $PYTHON_APP_USER $PYTHON_APP_DIR
fi

# Install essential packages
sudo DEBIAN_FRONTEND="noninteractive" apt-get install -y python3 python3-virtualenv python-virtualenv
sudo -u $PYTHON_APP_USER /usr/bin/virtualenv -p python3 $PYTHON_APP_DIR/venv
sudo wget https://github.com/mehulved/pta-hello-app/archive/v$PYTHON_APP_VERSION.tar.gz -O /usr/local/src/hello-app-v$PYTHON_APP_VERSION.tar.gz
sudo -u $PYTHON_APP_USER tar xzvf /usr/local/src/hello-app-v$PYTHON_APP_VERSION.tar.gz -C /tmp
sudo mv /tmp/pta-hello-app-$PYTHON_APP_VERSION/* $PYTHON_APP_DIR/
sudo mv /tmp/helloapp.service /etc/systemd/system/helloapp.service
sudo mv /tmp/helloapp.socket /etc/systemd/system/helloapp.socket
sudo mv /tmp/helloapp.tmpfiles.conf /usr/lib/tmpfiles.d/helloapp.conf
sudo sed -i "s*<PYTHON_APP_DIR>*$PYTHON_APP_DIR*g" /etc/systemd/system/helloapp.*
sudo sed -i "s/<PYTHON_APP_USER>/$PYTHON_APP_USER/g" /etc/systemd/system/helloapp.*
sudo sed -i "s/<PYTHON_APP_USER>/$PYTHON_APP_USER/g" /usr/lib/tmpfiles.d/helloapp.conf
set -x
sudo -u $PYTHON_APP_USER PATH=$PYTHON_APP_DIR/venv/bin/:$PATH VIRTUAL_ENV=$PYTHON_APP_DIR/venv/ $PYTHON_APP_DIR/venv/bin/pip install -r $PYTHON_APP_DIR/requirements.txt
set +x
sudo systemctl enable helloapp.socket
sudo systemctl enable helloapp.service
sudo systemctl start helloapp.socket
sudo systemctl start helloapp.service
