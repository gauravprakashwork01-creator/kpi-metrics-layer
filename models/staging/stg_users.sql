select
  cast(user_id as integer) as user_id,
  cast(signup_date as date) as signup_date,
  lower(trim(signup_channel)) as signup_channel,
  upper(trim(country)) as country
from {{ source('raw', 'users') }}
