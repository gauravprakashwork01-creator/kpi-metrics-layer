select
  s.session_id,
  s.user_id,
  cast(s.session_start_ts as date) as session_date,
  date_trunc('month', s.session_start_ts) as session_month,
  s.device_type,
  s.session_minutes,
  s.is_conversion
from {{ ref('stg_sessions') }} s
