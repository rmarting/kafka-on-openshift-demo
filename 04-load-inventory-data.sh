#!/bin/bash

# OpenShift Environment
NAMESPACE=kafka-on-ocp-demo

echo "**********************************"
echo "Load data into Inventory Database"
echo "**********************************"

# Get the name of the MySQL pod
MYSQL_POD=$(oc get pods -l deployment=mysql-inventory -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')
echo "MySQL pod found: $MYSQL_POD"

# Define the local file path and remote file path
LOCAL_FILE=./00-databases/mysql/inventory/data/inventory-data.sql
REMOTE_FILE=/tmp/data.sql

# Copy the script file to the pod container
oc cp $LOCAL_FILE $MYSQL_POD:$REMOTE_FILE

# Run the script inside the container
oc exec $MYSQL_POD -- bash -c 'mysql -u mysqluser -pmysqlpw inventory < /tmp/data.sql'
