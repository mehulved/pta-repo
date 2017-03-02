#!/bin/bash

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
if [[ ! -d $PYTHON_APP_HOME ]]
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
