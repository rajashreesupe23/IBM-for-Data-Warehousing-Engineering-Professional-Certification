# import the libraries

from datetime import timedelta
# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG
# Operators; we need this to write tasks!
from airflow.operators.bash_operator import BashOperator
# This makes scheduling easy
from airflow.utils.dates import days_ago

#defining DAG arguments

default_args = {
    'owner':'Rajashree Supe',
    'start_date': days_ago(0),
    'email': ['rj589@gmail.com'],
    'email_on_failure': True,
    'email_on_retry':True,
    'retries':1,
    'retry_delay':timedelta(minutes=5),
}

# defining the DAG

# define the DAG
dag = DAG(
    'ETL_toll_data',
    default_args=default_args,
    description='Apache Airflow Final Assignment',
    schedule_interval=timedelta(days=1),
)

# define the tasks

# Unzip task

unzip_data = BashOperator(
    task_id='unzip_data',
    bash_command='tar -zxf /home/project/airflow/dags/finalassignment/tolldata.tgz',
    dag=dag,
)

# Extract task

extract_data_from_csv=BashOperator(
    task_id='extract_data_from_csv',
    bash_command='cut -d "," -f1 1-4 vehicle-data.csv > csv_data.csv',
    dag=dag,
)

extract_data_from_tsv=BashOperator(
    task_id='extract_data_from_tsv',
    bash_command='cut -f1 5-7 tollplaza-data.tsv > tsv_data.csv',
    dag=dag,
)

extract_data_from_fixed_width=BashOperator(
    task_id='extract_data_from_fixed_width',
    bash_command="cat payment-data.txt | tr -s '[:space:]' | cut -d' ' -f11,12 > fixed_width_data.csv",
    dag=dag,
)

consolidate_data=BashOperator(
    task_id='consolidate_data',
    bash_command='paste csv_data.csv tsv_data.csv fixed_width_data.csv > extracted_data.csv',
    dag=dag,
)

# Transform task

transform_data=BashOperator(
    task_id='transform_data',
    bash_command='paste <(cut -d "," -f 1-6 /home/project/airflow/dags/finalassignment/extracted_data.csv) <(cut -d "," -f 7  | tr "[a-z]" "[A-Z]" )',
    dag=dag,
)

# task pipeline

unzip_data >> extract_data_from_csv >> extract_data_from_tsv >> extract_data_from_fixed_width >> consolidate_data >> transform_data