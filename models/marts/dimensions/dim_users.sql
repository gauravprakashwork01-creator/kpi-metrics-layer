with users as (
  select *
  from {{ ref('stg_users') }}
),

first_purchase as (
  select
    user_id,
    min(cast(transaction_ts as date)) as first_purchase_date
  from {{ ref('stg_transactions') }}
  where status = 'completed'
  group by 1
)

select
  u.user_id,
  u.signup_date,
  date_trunc('month', u.signup_date) as signup_month,
  u.signup_channel,
  u.country,
  fp.first_purchase_date,
  case when fp.first_purchase_date is not null then 1 else 0 end as has_purchased
from users u
left join first_purchase fp
  on u.user_id = fp.user_id
