/* 
question :what are the top skills based on salary ?
-look at the average salary associated with each skill for data anlayst positions
-focuses on roles with specified salaries,regardless of loaction
-why? it reveals how different skills imapct salary levels for data analyst and help identify the most finacially rewarding skills to aquire or improve
*/

select 
    skills,
    round(avg(salary_year_avg),0) as avg_salary
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
where 
    job_title_short='Data Analyst' 
    and salary_year_avg is not null
    and job_work_from_home=True
group by 
    skills
order BY
    avg_salary desc
limit 25