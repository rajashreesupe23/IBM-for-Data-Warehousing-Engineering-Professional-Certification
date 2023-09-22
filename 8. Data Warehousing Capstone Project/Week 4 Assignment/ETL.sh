#!/bin/sh

## Write your code here to load the data from sales_data table in Mysql server to a sales.csv.

mysql --host=127.0.0.1 --user=root --password=MTEzNjEtcmFqYXNo sales -e "SELECT * INTO OUTFILE '/home/project/sales.csv' CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' FROM sales_data"

## Select the data which is not more than 4 hours old from the current time.


export PGPASSWORD=<Replace this with your PostgreSQLserver password>;


psql --username=postgres --host=localhost --dbname=sales_new -c "\COPY sales_data(rowid,product_id,customer_id,price,quantity,timestamp) FROM '/home/project/sales.csv' delimiter ',' ;" 

## Delete sales.csv present in location /home/project

rm -f /home/project/sales.csv

## Write your code here to load the DimDate table from the data present in sales_data table

psql --username=postgres --host=localhost --dbname=sales_new -c  "INSERT INTO DimDate (dateid, day, month, year)
SELECT DISTINCT
    dateid,
    EXTRACT(DAY FROM timestamp) AS day,
    EXTRACT(MONTH FROM timestamp) AS month,
    EXTRACT(YEAR FROM timestamp) AS year
FROM sales_data;"

## Write your code here to load the FactSales table from the data present in sales_data table

psql --username=postgres --host=localhost --dbname=sales_new -c  "INSERT INTO FactSales (rowid, product_id, custome_id, price, total_price)
SELECT
    rowid,
    product_id,
    customer_id,
    price,
    price * quantity AS total_price
FROM sales_data;"

## Write your code here to export DimDate table to a csv

psql --username=postgres --host=localhost --dbname=sales_new -c "\COPY DimDate TO '/home/project/dimdate.csv' WITH CSV HEADER;"

## Write your code here to export FactSales table to a csv

psql --username=postgres --host=localhost --dbname=sales_new -c "\COPY FactSales TO '/home/project/factsales.csv' WITH CSV HEADER;"

