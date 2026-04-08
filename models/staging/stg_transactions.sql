select
  cast(transaction_id as integer) as transaction_id,
  cast(user_id as integer) as user_id,
  cast(transaction_ts as timestamp) as transaction_ts,
  cast(amount_usd as numeric(12,2)) as amount_usd,
  lower(trim(status)) as status
from {{ source('raw', 'transactions') }}
