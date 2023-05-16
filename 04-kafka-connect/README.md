# Deploying Kafka Connect Cluster

To deploy Kafka Connect requires create a initial `ImageStream` of the container image:

```shell
oc apply -f eda-kafka-connect-is.yaml 
```

It is needed because the KafkaConnect cluster will be built adding the Debezium Connectors
using the build capabilities of Red Hat AMQ Streams.

To deploy Kafka Connect cluster exposing metrics:

```shell
oc apply -f topics/
oc apply -f eda-kafka-connect.yaml
```

After some minutes the KafkaConnect Cluster will be ready:

```shell
❯ oc get kafkaconnect eda-kafka-connect -o yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnect
# ...
status:
  conditions:
  - lastTransitionTime: "2023-05-10T06:51:56.220922Z"
    status: "True"
    type: Ready
  connectorPlugins:
  - class: io.debezium.connector.mysql.MySqlConnector
    type: source
    version: 1.9.7.Final-redhat-00003
  - class: io.debezium.connector.postgresql.PostgresConnector
    type: source
    version: 1.9.7.Final-redhat-00003
  - class: org.apache.kafka.connect.mirror.MirrorCheckpointConnector
    type: source
    version: 3.3.1.redhat-00008
  - class: org.apache.kafka.connect.mirror.MirrorHeartbeatConnector
    type: source
    version: 3.3.1.redhat-00008
  - class: org.apache.kafka.connect.mirror.MirrorSourceConnector
    type: source
    version: 3.3.1.redhat-00008
  labelSelector: strimzi.io/cluster=eda-kafka-connect,strimzi.io/name=eda-kafka-connect-connect,strimzi.io/kind=KafkaConnect
  observedGeneration: 1
  replicas: 1
  url: http://eda-kafka-connect-connect-api.kafka-on-ocp-demo.svc:8083
```

The `status` lists the different KafkaConnectors available to use in this KafkaConnect cluster.

## Deploying Debezium Connectors

To deploy the Debezium Connectors for MySQL to get the events from the MySQL Databases:

```shell
oc apply -f debezium-mysql/
```

To check the status of the current `KafkaConnectors` deployed:

```shell
❯ oc get kafkaconnector
NAME                                CLUSTER             CONNECTOR CLASS                              MAX TASKS   READY
mysql-enterprise-source-connector   eda-kafka-connect   io.debezium.connector.mysql.MySqlConnector   1           True
mysql-inventory-source-connector    eda-kafka-connect   io.debezium.connector.mysql.MySqlConnector   1           True
```
