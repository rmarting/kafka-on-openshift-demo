# Deploying Enterprise Databases

## MySQL

### Enterprise Database

Sample database with a model of regions, clients, accounts and movements.

To build this image:

```shell
oc new-build ./mysql/enterprise --name=mysql-enterprise
oc start-build mysql-enterprise --from-dir=./mysql/enterprise --follow
oc new-app mysql-enterprise:latest -e MYSQL_ROOT_PASSWORD=debezium -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw
oc label deployment mysql-enterprise app.kubernetes.io/part-of=mysql-databases
```

To verify the new database:

```shell
❯ oc rsh $(oc get pods -l deployment=mysql-enterprise -o jsonpath='{.items[0].metadata.name}')
$ mysql -u $MYSQL_USER -p$MYSQL_PASSWORD enterprise
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| enterprise         |
+--------------------+
2 rows in set (0.01 sec)

mysql> show tables;
+----------------------+
| Tables_in_enterprise |
+----------------------+
| accounts             |
| clients              |
| movements            |
| regions              |
+----------------------+
4 rows in set (0.00 sec)
```

### Inventory Database

Sample database with a model of customers, products and orders.

```shell
oc new-build ./mysql/inventory --name=mysql-inventory
oc start-build mysql-inventory --from-dir=./mysql/inventory --follow
oc new-app mysql-inventory:latest -e MYSQL_ROOT_PASSWORD=debezium -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw
oc label deployment mysql-inventory app.kubernetes.io/part-of=mysql-databases
```

```shell
❯ oc rsh $(oc get pods -l deployment=mysql-inventory -o jsonpath='{.items[0].metadata.name}')
$ mysql -u $MYSQL_USER -p$MYSQL_PASSWORD inventory
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| inventory          |
+--------------------+
2 rows in set (0.00 sec)

mysql> show tables;
+---------------------+
| Tables_in_inventory |
+---------------------+
| addresses           |
| customers           |
| geom                |
| orders              |
| products            |
| products_on_hand    |
+---------------------+
6 rows in set (0.00 sec)
```
