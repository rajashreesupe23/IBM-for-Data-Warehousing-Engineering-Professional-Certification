#!/bin/bash

echo "extract_transform_and_load"
cut -d "#" -f 1,4 web-server-access-log.txt > /home/project/airflow/dags/extracted.txt

paste <(cut -d "#" -f 1 /home/project/airflow/dags/extracted.txt) <(cut -d "#" -f 2 /home/project/airflow/dags/extracted.txt | tr "[a-z]" "[A-Z]" ) > /home/project/airflow/dags/capitalized.txt > /home/project/airflow/dags/capitalized.txt

zip log.tar.gz capitalized.txt