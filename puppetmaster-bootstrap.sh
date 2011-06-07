#!/bin/sh

apt-get update
apt-get upgrade -y
apt-get install -y puppetmaster git
/etc/init.d/puppetmaster stop

rm -rf /etc/puppet
git clone git://github.com/khaong/tw-cd-demo-puppet.git /etc/puppet

/etc/init.d/puppetmaster start