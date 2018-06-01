#!/bin/bash
#
# Put all the reports into our s3 bucket
[[ -z "$1" ]] && bucketname=jmeter-report-bucket || bucketname=$1

cd reports

aws s3 cp . s3://$1/ --recursive