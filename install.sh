#!/bin/sh

sudo mkdir /usr/apache
sudo chmod 777 /usr/apache

cd /tmp

echo "installing java 8"
sudo wget https://s3.amazonaws.com/ws-devops-resources/jdk-8u171-linux-x64.rpm
sudo yum install -y jdk-8u171-linux-x64.rpm
sudo update-alternatives --config java
sudo update-alternatives --config javac
echo "java 8 installed and configured"

echo "installing maven"
wget https://s3.amazonaws.com/ws-devops-resources/apache-maven-3.5.4-bin.tar.gz
tar xvf apache-maven-3.5.4-bin.tar.gz
sudo mv apache-maven-3.5.4 /usr/apache
sudo chmod 777 -R /usr/apache/apache-maven-3.5.4
echo "M2_HOME=/usr/apache/apache-maven-3.5.4" >> ~/.bashrc
echo "export M2_HOME" >> ~/.bashrc
echo "export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bashrc
sudo exec  ~/.bashrc
echo "maven installed"

# echo "installing maven"
# sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
# sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
# sudo yum install -y apache-maven
# echo "maven installed"

echo "downloading tomcat tar.gz"
wget https://s3.amazonaws.com/ws-devops-resources/apache-tomcat-9.0.10.tar.gz
sudo tar -xzvf apache-tomcat-9.0.10.tar.gz
echo "giving ec2-user permission for tomcat"
sudo chmod 777 -R apache-tomcat-9.0.10
sudo mv apache-tomcat-9.0.10 /usr/apache/
sudo sed -i 's/<Connector port="8080"/<Connector port="8090"/' /usr/apache/apache-tomcat-9.0.10/conf/server.xml
sudo sh /usr/apache/apache-tomcat-9.0.10/bin/startup.sh
echo "CATALINA_HOME=/usr/apache/apache-tomcat-9.0.10"  >> ~/.bashrc
echo "export CATALINA_HOME"  >> ~/.bashrc

echo "installing node"
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

echo "installing jenkins"
sudo wget https://s3.amazonaws.com/ws-devops-resources/jenkins-2.131-1.1.noarch.rpm
sudo yum install jenkins-2.131-1.1.noarch.rpm -y
echo "jenkins installed now starting"
sudo service jenkins start
echo "jenkins started"
