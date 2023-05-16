# Knative Serverless

This section of the architecture is based in Serverless. We will deploy the different
services of the solution as Knative Services, based in Red Hat OpenShift Serverless.

## Deploying Serving Services

To deploy the Knative Serving services:

```shell
oc create -f knative-serving/knative-serving.yaml
```

To verify that Knative Serving Services are available:

```shell
❯ oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'
DependenciesInstalled=True
DeploymentsAvailable=True
InstallSucceeded=True
Ready=True
VersionMigrationEligible=True
```

## Deploying Eventing Services

To deploy the Knative Serving services:

```shell
oc create -f knative-eventing/knative-eventing.yaml
```

To verify that Knative Eventing Services are available:

```shell
❯ oc get knativeeventing.operator.knative.dev/knative-eventing -n knative-eventing --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'
DependenciesInstalled=True
DeploymentsAvailable=True
InstallSucceeded=True
Ready=True
VersionMigrationEligible=True
```

Enable Serverless Eventing to manage Kafka cluster deploying a `KnativeKafka` definition using
the current Apache Kafka cluster deployed:

```shell
oc apply -f knative-eventing/knative-kafka.yaml -n knative-eventing
```

## Deploying Application Serverless Services

To deploy our Application Serverless Services:

```shell
oc apply -f service/
```

You could check the Application Serverless Services

```shell
❯ kn service list
NAME                        URL                                                                      LATEST                            AGE    CONDITIONS   READY
event-display-serverless    http://event-display-serverless-eda-workshop.apps.sandbox.opentlc.com    event-display-serverless-00001    113s   3 OK / 3     True
NAME                                  URL                                                                                                              LATEST                                      AGE     CONDITIONS   READY   REASON
enterprise-event-display-serverless   https://enterprise-event-display-serverless-kafka-on-ocp-demo.apps.opentlc.com   enterprise-event-display-serverless-00001   2m53s   3 OK / 3     True    
inventory-event-display-serverless    https://inventory-event-display-serverless-kafka-on-ocp-demo.apps.opentlc.com    inventory-event-display-serverless-00001    2m53s   3 OK / 3     True  
```

Deploy Kafka Sources to consume messages from Kafka to start up the services

```shell
oc apply -f knative-eventing/kafka-source
```

You could check the `KafkaSource` objects:

```shell
❯ oc get kafkasource
NAME                                    TOPICS                                                                                                                  BOOTSTRAPSERVERS                                           READY   REASON   AGE
enterprise-event-display-kafka-source   ["db.enterprise.accounts","db.enterprise.clients","db.enterprise.movements","db.enterprise.regions"]                    ["event-bus-kafka-bootstrap.kafka-on-ocp-demo.svc:9092"]   True             26s
inventory-event-display-kafka-source    ["db.inventory.addresses","db.inventory.customers","db.inventory.geom","db.inventory.orders","db.inventory.products"]   ["event-bus-kafka-bootstrap.kafka-on-ocp-demo.svc:9092"]   True             26s
```

Now every time a new message is sent to any `db.enterprise.*` topics or `db.inventory.*` topics, the message
will be processed by the right `event-display` instance:
