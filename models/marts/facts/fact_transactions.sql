select
  t.transaction_id,
  t.user_id,
  cast(t.transaction_ts as date) as transaction_date,
  date_trunc('month', t.transaction_ts) as transaction_month,
  t.status,
  case when t.status = 'completed' then t.amount_usd else 0 end as gross_revenue_usd,
  case when t.status = 'refunded' then t.amount_usd else 0 end as refunded_amount_usd,
  case when t.status = 'completed' then t.amount_usd
       when t.status = 'refunded' then -t.amount_usd
       else 0 end as net_revenue_usd
from {{ ref('stg_transactions') }} t
