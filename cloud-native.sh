#!/bin/sh
cd /tmp

echo "installing java 8"
wget https://s3-us-west-2.amazonaws.com/blake-dev-ops-resources/jdk-8u171-linux-x64.rpm
sudo yum install -y jdk-8u171-linux-x64.rpm
sudo update-alternatives --config java
sudo update-alternatives --config javac
echo "java 8 installed and configured"

echo "installing node"
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

echo "installing jenkins"
wget https://s3-us-west-2.amazonaws.com/blake-dev-ops-resources/jenkins-2.89.4-1.1.noarch.rpm
sudo yum install jenkins-2.89.4-1.1.noarch.rpm -y
echo "jenkins installed now starting"
sudo service jenkins start
echo "jenkins started"
