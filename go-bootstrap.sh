#!/bin/sh

sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
sudo apt-get update

echo "sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true" | sudo -E debconf-set-selections
sudo apt-get install -y -f unzip sun-java6-jdk
sudo apt-get install git ruby rubygems sqlite3
sudo gem install bundler rake

wget http://download01.thoughtworks.com/go/2.2/ga/go-server-2.2.0-13083.deb
wget http://download01.thoughtworks.com/go/2.2/ga/go-agent-2.2.0-13083.deb

dpkg -i go-*


