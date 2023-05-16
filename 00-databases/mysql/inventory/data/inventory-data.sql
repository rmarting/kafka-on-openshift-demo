# Switch to this database
USE inventory;

# Create and populate our products using a single insert with many rows
ALTER TABLE products AUTO_INCREMENT = 101;

INSERT INTO products
VALUES (default,"scooter","Small 2-wheel scooter",3.14),
       (default,"car battery","12V car battery",8.1),
       (default,"12-pack drill bits","12-pack of drill bits with sizes ranging from #40 to #3",0.8),
       (default,"hammer","12oz carpenter's hammer",0.75),
       (default,"hammer","14oz carpenter's hammer",0.875),
       (default,"hammer","16oz carpenter's hammer",1.0),
       (default,"rocks","box of assorted rocks",5.3),
       (default,"jacket","water resistent black wind breaker",0.1),
       (default,"spare tire","24 inch spare tire",22.2);

# Create and populate the products on hand using multiple inserts
INSERT INTO products_on_hand VALUES (101,3);
INSERT INTO products_on_hand VALUES (102,8);
INSERT INTO products_on_hand VALUES (103,18);
INSERT INTO products_on_hand VALUES (104,4);
INSERT INTO products_on_hand VALUES (105,5);
INSERT INTO products_on_hand VALUES (106,0);
INSERT INTO products_on_hand VALUES (107,44);
INSERT INTO products_on_hand VALUES (108,2);
INSERT INTO products_on_hand VALUES (109,5);

# Create some customers ...
ALTER TABLE customers AUTO_INCREMENT = 1001;

INSERT INTO customers
VALUES (default,"Sally","Thomas","2sally.thomas@acme.com"),
       (default,"George","Bailey","2gbailey@foobar.com"),
       (default,"Edward","Walker","2ed@walker.com"),
       (default,"Anne","Kretchmar","2annek@noanswer.org");

INSERT INTO customers
VALUES (default,"Sally","Thomas","6sally.thomas@acme.com"),
       (default,"George","Bailey","6gbailey@foobar.com"),
       (default,"Edward","Walker","6ed@walker.com"),
       (default,"Anne","Kretchmar","6annek@noanswer.org");

# Create some fake addresses
INSERT INTO addresses
VALUES (default,1001,'3183 Moore Avenue','Euless','Texas','76036','SHIPPING'),
       (default,1001,'2389 Hidden Valley Road','Harrisburg','Pennsylvania','17116','BILLING'),
       (default,1002,'281 Riverside Drive','Augusta','Georgia','30901','BILLING'),
       (default,1003,'3787 Brownton Road','Columbus','Mississippi','39701','SHIPPING'),
       (default,1003,'2458 Lost Creek Road','Bethlehem','Pennsylvania','18018','SHIPPING'),
       (default,1003,'4800 Simpson Square','Hillsdale','Oklahoma','73743','BILLING'),
       (default,1004,'1289 University Hill Road','Canehill','Arkansas','72717','LIVING');

# Create some very simple orders
INSERT INTO orders
VALUES (default, '2016-01-16', 1001, 1, 102),
       (default, '2016-01-17', 1002, 2, 105),
       (default, '2016-02-19', 1002, 2, 106),
       (default, '2016-02-21', 1003, 1, 107);

# Create table with Spatial/Geometry type
INSERT INTO geom
VALUES(default, ST_GeomFromText('POINT(1 1)'), NULL),
      (default, ST_GeomFromText('LINESTRING(2 1, 6 6)'), NULL),
      (default, ST_GeomFromText('POLYGON((0 5, 2 5, 2 7, 0 7, 0 5))'), NULL);
