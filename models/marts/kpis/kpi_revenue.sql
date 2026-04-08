select
  transaction_month,
  sum(gross_revenue_usd) as gross_revenue_usd,
  sum(refunded_amount_usd) as refunded_amount_usd,
  sum(net_revenue_usd) as net_revenue_usd,
  count(distinct case when net_revenue_usd > 0 then user_id end) as paying_users
from {{ ref('fact_transactions') }}
group by 1
order by 1
