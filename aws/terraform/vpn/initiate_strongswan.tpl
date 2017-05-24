#!/bin/bash

apt-get update -y
apt-get install strongswan strongswan-starter -y
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.send_redirects=0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.accept_redirects=0' >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
