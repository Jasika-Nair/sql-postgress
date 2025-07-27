# Introduction
Dive into the data job market!
This project focuses on Data Analyst roles, exploring:

Top-paying jobs

In-demand skills

Where high demand meets high salary in data analytics.

🔍 SQL Queries?
Check them out here 👉 project_sql folder
# Background
Driven by a desire to navigate the Data Analyst job market more effectively, this project was created to pinpoint top-paying roles and identify in-demand skills—ultimately streamlining the job search process and highlighting the most optimal skills to learn.

### 🔎 Key Questions Answered via SQL:
1. What are the top-paying Data Analyst jobs?

2. What skills are required for these top-paying jobs?

3. Which skills are most in demand for Data Analyst roles?

4. Which skills are associated with higher salaries?

5. What are the most optimal skills to learn for maximum impact?

# Tools I used
1. SQL – for querying and analyzing job market data

2. PostgreSQL – as the SQL database engine to run and test queries

3. Git – for version control of the project

4. GitHub – to host the project and showcase the work publicly

5. VS Code – as the code editor for writing and organizing SQL scripts

# The Analysis

### 1. What are the top-paying Data Analyst jobs?
To identify the highest-paying data analyst roles, we filtered job postings that:

Have the job title "Data Analyst"

Offer a non-null average annual salary

Are listed as remote (i.e., job_location = 'Anywhere')

This query helps spotlight the top 10 highest-paying remote data analyst jobs across all companies, giving a strong sense of where the best salary opportunities lie.

```sql
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
```
### 2. PostgreSQL – as the SQL database engine to run and test queries

To identify the most valuable skills, we first selected the top 10 highest-paying remote Data Analyst jobs. Then, we joined the results with the skills_job_dim and skills_dim tables to extract the skills required for these top roles.

```sql
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
/*
SQL + Python are the most in-demand core skills.

Tableau is the top visualization tool.

R, Excel, Pandas are still widely used.

Cloud & DevOps tools like Snowflake, Azure, Bitbucket are appearing in top roles.

*/

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

```

### 3. Which skills are most in demand for Data Analyst roles?
To find the most in-demand skills, we analyzed all remote Data Analyst job postings and counted how often each skill appeared. This helps identify which skills are most sought after by employers.

This query reveals the top 5 most in-demand skills for remote Data Analyst roles, based on how frequently they appear in job listings. These are the skills job seekers should prioritize learning to improve their chances in the job market.

```sql
/*
Question:what are the most in demand skills for data anlyst?
-join job postings to inner joi table similar to query 2
-identify the top 5 in demand skills for a data anlyst
-focus on all job postings
-why? retrieves the top 5 skills with highest demand in the job market,providing
insights into the most valuable skills for job seekers.
*/
select 
    skills,
    count(skills_job_dim.job_id) as demand_count
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
where 
    job_title_short='Data Analyst' and
    job_work_from_home=True
group by 
    skills
order BY
    demand_count desc
limit 5

``` 
### 4. Which skills are associated with higher salaries?
This analysis helps determine which skills are linked to higher average salaries in remote Data Analyst roles. It can guide professionals looking to upskill for better-paying opportunities.

This reveals the top 25 skills that correlate with higher average salaries, helping identify which technical tools or languages are more valuable in terms of compensation.

```sql
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
```

### 5. What are the most optimal skills to learn for maximum impact?
This final query combines demand and salary data to find the most impactful skills—those that are both in high demand and associated with high pay. We also filtered out skills that appear in fewer than 10 job listings to focus on statistically significant results.
The result gives a balanced view of value and popularity—a guide for aspiring analysts to prioritize learning skills that will give them the best return in the job market.



```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id,
    skills_dim.skills
HAVING 
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

# What I Learned

1. Gained hands-on experience with SQL using PostgreSQL to analyze real-world job market data.

2. Learned how to use JOINs, GROUP BY, CTEs, and aggregate functions effectively.

3. Understood how to derive actionable insights from job listings by filtering and combining multiple tables.

4. Practiced working with Git and GitHub for version control and project documentation.

5. Developed confidence in identifying in-demand skills and high-paying trends for data analyst roles.

# Conclusions

This project gave me a deeper understanding of how to use SQL in a practical, career-focused way.
By analyzing job market data, I was able to:

1. Discover which skills are most in demand

2. Understand what skills lead to higher salaries

3. Identify the optimal skills to learn for someone entering the Data Analytics field

Aspiring data analysts can better position themselves in a competitive job market by focusing on high demand ,high salary skills .
Overall, this analysis reinforced how data-driven decisions can simplify job market navigation and improve career planning.


