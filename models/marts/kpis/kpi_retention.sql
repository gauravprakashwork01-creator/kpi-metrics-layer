with cohorts as (
  select
    user_id,
    date_trunc('month', signup_date) as cohort_month
  from {{ ref('dim_users') }}
),

activity as (
  select distinct
    user_id,
    session_month as active_month
  from {{ ref('fact_sessions') }}
),

cohort_activity as (
  select
    c.cohort_month,
    a.active_month,
    datediff(month, c.cohort_month, a.active_month) as months_since_signup,
    count(distinct a.user_id) as active_users
  from cohorts c
  join activity a
    on c.user_id = a.user_id
  where a.active_month >= c.cohort_month
  group by 1,2,3
),

cohort_sizes as (
  select
    cohort_month,
    count(distinct user_id) as cohort_size
  from cohorts
  group by 1
)

select
  ca.cohort_month,
  ca.active_month,
  ca.months_since_signup,
  cs.cohort_size,
  ca.active_users,
  cast(ca.active_users as float) / nullif(cs.cohort_size, 0) as retention_rate
from cohort_activity ca
join cohort_sizes cs
  on ca.cohort_month = cs.cohort_month
order by 1,2
