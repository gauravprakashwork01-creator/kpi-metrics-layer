select
  session_month,
  count(*) as total_sessions,
  sum(case when is_conversion = 1 then 1 else 0 end) as converted_sessions,
  cast(sum(case when is_conversion = 1 then 1 else 0 end) as float)
    / nullif(count(*), 0) as conversion_rate
from {{ ref('fact_sessions') }}
group by 1
order by 1
