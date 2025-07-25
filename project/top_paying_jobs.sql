/*
questions:what are the top paying data analyst jobs?
-identify the top 10 highest paying data anlayst roles available remotely
-fouses on job postings with specified salaries (remove nulls)
*/

select 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
from 
     job_postings_fact
left join company_dim on job_postings_fact.company_id=company_dim.company_id

WHERE
    job_title_short='Data Analyst' AND
    job_location='Anywhere' and salary_year_avg is not null
order BY
    salary_year_avg desc
limit 10