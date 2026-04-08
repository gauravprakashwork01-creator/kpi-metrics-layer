select
  cast(session_id as varchar) as session_id,
  cast(user_id as integer) as user_id,
  cast(session_start_ts as timestamp) as session_start_ts,
  cast(session_end_ts as timestamp) as session_end_ts,
  lower(trim(device_type)) as device_type,
  cast(is_conversion as integer) as is_conversion,
  datediff(minute, cast(session_start_ts as timestamp), cast(session_end_ts as timestamp)) as session_minutes
from {{ source('raw', 'sessions') }}
