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

# define the task **extract_transform_and_load** to call shell script

#calling the shell script
extract_transform_load = BashOperator(
    task_id="extract_transform_load",
    bash_command="/home/project/airflow/dags/Extract_Transform_data.sh ",
    dag=dag,
)

# task pipeline

extract_transform_load
