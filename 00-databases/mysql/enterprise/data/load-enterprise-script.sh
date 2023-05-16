#!/bin/bash

# MySQL database credentials
DB_USER="mysqluser"
DB_PASS="mysqlpw"
DB_NAME="enterprise"

# Create array of data
data=()
for i in {1..10}; do
  first_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
  last_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)  
  data+=("$first_name, $last_name")
done

# for value in "${data[@]}"
# do
#      echo $value
# done

# Loop through data and insert into database
for row in "${data[@]}"; do
    IFS=',' read -ra values <<< "$row"
    first_name="${values[0]}"
    last_name="${values[1]}"

    #echo "INSERT INTO clients VALUES (default,'$first_name','$last_name','$first_name@acme.com');"
    mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "INSERT INTO clients VALUES (default,'$first_name','$last_name','$first_name@acme.com');"    
    sleep .5
done
