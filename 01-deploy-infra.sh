#!/bin/bash

# OpenShift Environment
NAMESPACE=kafka-on-ocp-demo

source 00-ocp-utils.sh

echo "********************************************"
echo "Creating Telco Innovation on OpenShift Demo"
echo "********************************************"

create_namespace $NAMESPACE

echo "**********************************"
echo "Deploying Databases"
echo "**********************************"

echo "**********************************"
echo "Deploying Enterprise Database"
echo "**********************************"

create_build_config "mysql-enterprise" "./00-databases/mysql/enterprise" $NAMESPACE
check_build_completed "mysql-enterprise" $NAMESPACE

create_new_app "mysql-enterprise" "mysql-enterprise:latest" $NAMESPACE "-e MYSQL_ROOT_PASSWORD=debezium -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw" "app.kubernetes.io/part-of=mysql-databases"

echo "**********************************"
echo "Deploying Inventory Database"
echo "**********************************"

create_build_config "mysql-inventory" "./00-databases/mysql/inventory" $NAMESPACE
check_build_completed "mysql-inventory" $NAMESPACE

create_new_app "mysql-inventory" "mysql-inventory:latest" $NAMESPACE "-e MYSQL_ROOT_PASSWORD=debezium -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw" "app.kubernetes.io/part-of=mysql-databases"

echo "**********************************"
echo "Deploying Cluster Wide Operators"
echo "**********************************"

oc apply -f 01-operators/

check_operator_ready "AMQ Streams" $NAMESPACE
check_operator_ready "Red Hat OpenShift Serverless" $NAMESPACE
check_operator_ready "Red Hat Integration - Service Registry Operator" $NAMESPACE
check_operator_ready "Red Hat Integration - Camel K" $NAMESPACE

echo "**********************************"
echo "Deploying Event Bus - Apache Kafka"
echo "**********************************"

oc apply -f 02-kafka/kafka/event-bus-kafka.yaml

check_kafka_deployed "event-bus" $NAMESPACE

echo "**********************************"
echo "Deploying Kafka Topics"
echo "**********************************"

oc apply -f 02-kafka/topics

echo "**********************************"
echo "Deploying Apicurio Service Registry"
echo "**********************************"

oc apply -f 03-service-registry/apicurio-registry.yaml

check_deployment_ready "eda-registry-deployment" $NAMESPACE

echo "**********************************"
echo "Deploying Kafka Connect Cluster"
echo "**********************************"

oc apply -f 04-kafka-connect/topics/
oc apply -f 04-kafka-connect/eda-kafka-connect-is.yaml
oc apply -f 04-kafka-connect/eda-kafka-connect.yaml

check_kafkaconnect_deployed "eda-kafka-connect" $NAMESPACE

echo "**********************************"
echo "Deploying Kafka Connectors"
echo "**********************************"

oc apply -f 04-kafka-connect/debezium-mysql/mysql-enterprise-source-connector.yaml
oc apply -f 04-kafka-connect/debezium-mysql/mysql-inventory-source-connector.yaml

echo "**********************************"
echo "Deploying Serverless Services"
echo "**********************************"

echo "**********************************"
echo "Deploying Serverless Serving"
echo "**********************************"

oc apply -f 05-serverless/knative-serving/knative-serving.yaml

check_knative_serving_ready "knative-serving"

oc apply -f 05-serverless/service/

echo "**********************************"
echo "Deploying Serverless Eventing"
echo "**********************************"

oc apply -f 05-serverless/knative-eventing/knative-eventing.yaml
oc apply -f 05-serverless/knative-eventing/knative-kafka.yaml -n knative-eventing

check_knative_eventing_ready "knative-eventing"

oc apply -f 05-serverless/knative-eventing/kafka-source

echo "**********************************"
echo "Deploying Kamelets"
echo "**********************************"

oc apply -f 06-kamelets/

echo "**********************************"
echo "Deploying Kafka-UI"
echo "**********************************"

helm upgrade --install kafka-ui kafka-ui/kafka-ui -f kafka-ui/values.yaml --history-max 2

check_deployment_ready "kafka-ui" $NAMESPACE
