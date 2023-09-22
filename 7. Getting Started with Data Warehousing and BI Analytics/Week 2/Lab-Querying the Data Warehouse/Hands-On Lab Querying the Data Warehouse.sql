--Exercise 2 - Write a query using grouping sets
--grouping sets
select year,category, sum(billedamount) as totalbilledamount
from factbilling 
left join dimcustomer 
on factbilling.customerid = dimcustomer.customerid
left join dimmonth 
on factbilling.monthid = dimmonth.monthid
group by grouping sets(year,category)
order by year, category;

with cte as
(select year,category, sum(billedamount) as totalbilledamount
from factbilling 
left join dimcustomer 
on factbilling.customerid = dimcustomer.customerid
left join dimmonth 
on factbilling.monthid = dimmonth.monthid
group by grouping sets(year,category)
order by year, category
)
select count(*) from cte;

--Exercise 3 - Write a query using rollup
--rollup
select year,category, sum(billedamount) as totalbilledamount
from factbilling
left join dimcustomer
on factbilling.customerid = dimcustomer.customerid
left join dimmonth
on factbilling.monthid=dimmonth.monthid
group by rollup(year,category)
order by year, category;

with cte as
(select year,category, sum(billedamount) as totalbilledamount
from factbilling 
left join dimcustomer 
on factbilling.customerid = dimcustomer.customerid
left join dimmonth 
on factbilling.monthid = dimmonth.monthid
group by rollup(year,category)
order by year, category
)
select count(*) from cte;

--Exercise 4 - Write a query using cube
--cube
select year,category, sum(billedamount) as totalbilledamount
from factbilling
left join dimcustomer
on factbilling.customerid = dimcustomer.customerid
left join dimmonth
on factbilling.monthid=dimmonth.monthid
group by cube(year,category)
order by year, category;

with cte as
(select year,category, sum(billedamount) as totalbilledamount
from factbilling 
left join dimcustomer 
on factbilling.customerid = dimcustomer.customerid
left join dimmonth 
on factbilling.monthid = dimmonth.monthid
group by cube(year,category)
order by year, category
)
select count(*) from cte;

--Exercise 5 - Create a Materialized Query Table(MQT)
create table countrystats(country,year,totalbilledamount) as 
(select country, year, sum(billedamount)
from factbilling 
left join dimcustomer 
on factbilling.customerid=dimcustomer.customerid
left join dimmonth 
on factbilling.monthid=dimmonth.monthid
group by country,year)
DATA INITIALLY DEFERRED 
REFRESH DEFERRED 
MAINTAINED BY SYSTEM;

select country, year, sum(billedamount)
from factbilling
left join dimcustomer
on factbilling.customerid = dimcustomer.customerid
left join dimmonth
on factbilling.monthid=dimmonth.monthid
group by country,year;

--Populate/refresh data into the MQT
refresh table countrystats;

select * from countrystats;


--Create a grouping set for the columns year, quartername, sum(billedamount).
select year, quartername, sum(billedamount)
from factbilling 
left join dimcustomer 
on factbilling.customerid=dimcustomer.customerid
left join dimmonth 
on factbilling.monthid=dimmonth.monthid
group by grouping sets(year, quartername);

--Create a rollup for the columns country, category, sum(billedamount).
select country, category, sum(billedamount)
from factbilling 
left join dimcustomer 
on factbilling.customerid=dimcustomer.customerid
left join dimmonth 
on factbilling.monthid=dimmonth.monthid
group by rollup(country, category);

--Create a cube for the columns year,country, category, sum(billedamount).
select year, country, category, sum(billedamount)
from factbilling 
left join dimcustomer 
on factbilling.customerid=dimcustomer.customerid
left join dimmonth 
on factbilling.monthid=dimmonth.monthid
group by cube(year, country, category);

--Create an MQT named average_billamount with columns year, quarter, category, country, average_bill_amount.
create table average_billamount(year, quarter, category, country, average_bill_amount) as 
(select year, quarter, category, country, avg(billedamount) as average_bill_amount
from factbilling 
left join dimcustomer 
on factbilling.customerid=dimcustomer.customerid
left join dimmonth 
on factbilling.monthid=dimmonth.monthid
group by year,quarter,category,country
)
DATA INITIALLY DEFERRED 
REFRESH DEFERRED 
MAINTAINED BY SYSTEM;

refresh table average_billamount;

