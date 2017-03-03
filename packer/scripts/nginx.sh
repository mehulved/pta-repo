#!/bin/bash

sudo DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx-light
sudo mv /tmp/helloapp.nginx.conf /etc/nginx/sites-available/helloapp
sudo ln -s /etc/nginx/sites-available/helloapp /etc/nginx/sites-enabled/helloapp
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

