#! bin/bash

# unzip the data
tar -zxf /home/project/airflow/dags/tolldata.tgz

# extract data from csv file
cut -d "," -f1 1-4 vehicle-data.csv > csv_data.csv

# extract data from tsv file
cut -f1 5-7 tollplaza-data.tsv > tsv_data.csv

# extract data from fixed width file
cat payment-data.txt | tr -s '[:space:]' | cut -d' ' -f11,12 > fixed_width_data.csv

# extracted from previous tasks
paste csv_data.csv tsv_data.csv fixed_width_data.csv > extracted_data.csv

# Transform and load the data
paste <(cut -d "," -f 1-6 /home/project/airflow/dags/extracted_data.csv) <(cut -d "," -f 7  | tr "[a-z]" "[A-Z]" )
