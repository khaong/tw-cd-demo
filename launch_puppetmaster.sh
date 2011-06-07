#!/bin/sh

ec2-run-instances ami-e2af508b -f puppetmaster-bootstrap.sh --instance-type m1.small -k tw-cd-demo -g PuppetMaster --availability-zone us-east-1b