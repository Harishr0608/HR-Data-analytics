select * from hrdata

COPY hrdata FROM 'D:\hrdata.csv' DELIMITER ',' CSV HEADER

-- KPI 

select sum(employee_count) as Employee_Count from hrdata

select count(attrition) as attrition_count from hrdata where attrition= 'Yes'

select round (((select count(attrition) from hrdata where attrition='Yes')/ sum(employee_count)) * 100, 2)
as attrition_rate from hrdata

select sum(employee_count) - (select count(attrition) from hrdata  where attrition='Yes') as active_employees from hrdata

select (select sum(employee_count) from hrdata) - count(attrition) as active_employee from hrdata
where attrition='Yes'

select sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Male')
as active_employees from hrdata  where gender = 'Male'

select round(avg(age), 0) as average_age from hrdata

--attrition by gender

select gender, count(attrition) from hrdata
where attrition = 'Yes' and education = 'High School'
group by gender
order by count(attrition) desc

--department wise attrition

select department, count(attrition),
round((cast(count(attrition) as numeric) /(select count(attrition) from  hrdata where attrition = 'Yes' and gender = 'Female'))*100, 2) as percentage
from hrdata
where attrition = 'Yes' and gender = 'Female'
group by department
order by count(attrition) desc

--no.of employees by age group

select age, sum(employee_count) from hrdata
where department = 'R&D'
group by age
order by age

select age_band, gender, sum(employee_count) from hrdata
group by age_band, gender
order by age_band, gender

--education wise attrition

select education_field, count(attrition) from hrdata
where attrition = 'Yes' and department = 'Sales'
group by education_field
order by count(attrition) desc

--attrition rate by gender from different age group

select age_band, gender, count(attrition), 
round((cast(count(attrition) as numeric)/(select count(attrition) from hrdata where attrition = 'Yes'))*100, 2) as percentage
from hrdata
where attrition = 'Yes'
group by age_band, gender
order by age_band, gender

--job satisfaction rating

CREATE EXTENSION IF NOT EXISTS tablefunc

SELECT *
FROM crosstab(
	'SELECT job_role, job_satisfaction, sum(employee_count)
	FROM hrdata
	GROUP BY job_role, job_satisfaction
	ORDER BY job_role, job_satisfaction'
) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;



