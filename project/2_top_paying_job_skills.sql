/* question:what skills are required for the top paying data analyst jobs?
-use the top 10 highest paying data anlayst jobs from first query
-add the specific skill required for these roles
-why? it provides a detailed look at which high-paying jobs demand certain skills, 
helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN 
        company_dim 
    ON 
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
order BY
salary_year_avg desc
;

/* most in demand skills in top paying data analyst jobs with rank and frequency in which they appear*/
SELECT 
    skills_dim.skill_id as  id ,
     RANK() OVER (ORDER BY COUNT(*) DESC) AS skill_rank,
    skills_dim.skills,
    count(*) as frequency
FROM top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
group by skills_dim.skills,skills_dim.skill_id
order BY
count(*) desc
;
/*
SQL + Python are the most in-demand core skills.

Tableau is the top visualization tool.

R, Excel, Pandas are still widely used.

Cloud & DevOps tools like Snowflake, Azure, Bitbucket are appearing in top roles.

*/
