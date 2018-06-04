#!/bin/bash

# Run all of our jmeter tests
# @TODO use real execution tool http://gettaurus.org/
# 1 SERVERNAME - name of the server you want to run the tests against
# 2 DATEFOLDER - must be within the testdata folder and include perfdata and ops user
#  example run  runAll.sh cloudpayroll-test-blue.ap-southeast-2.elasticbeanstalk.com awstest

[[ -z "$1" ]] && servername=google.com || servername=$1


# Confirm Payroll test
echo "Running Confirm Payroll"
./jmeter -n -t ~/workspace/jmeter-on-batch/src/PingDomain.jmx \
  -JSERVERNAME=google.com -l repots/google.jtl -e -o reports/google

# Publish to S3
echo "Publising to S3"
./putReports.sh $3