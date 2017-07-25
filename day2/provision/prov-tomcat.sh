#!/bin/bash

echo "====> Provision-script started! "

echo "==> Installing Tomcat"
yum install tomcat -y
yum -y install tomcat tomcat-webapps -y;
