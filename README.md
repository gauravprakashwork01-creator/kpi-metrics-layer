# KPI Dashboard & Metrics Layer (dbt-style)

This project demonstrates a **dbt-style analytics engineering structure** with staging, dimension/fact models, and KPI models that support dashboarding.

## Project Structure

```text
.
├── seeds/
│   └── raw/
│       ├── users.csv
│       ├── sessions.csv
│       └── transactions.csv
└── models/
    ├── sources.yml
    ├── schema.yml
    ├── staging/
    │   ├── stg_users.sql
    │   ├── stg_sessions.sql
    │   └── stg_transactions.sql
    └── marts/
        ├── dimensions/
        │   └── dim_users.sql
        ├── facts/
        │   ├── fact_sessions.sql
        │   └── fact_transactions.sql
        └── kpis/
            ├── kpi_conversion_rate.sql
            ├── kpi_retention.sql
            └── kpi_revenue.sql
```

## Data Layers

### 1) Raw datasets (`seeds/raw`)
- `users`: user profile + acquisition metadata.
- `transactions`: monetary events with status (`completed`, `refunded`).
- `sessions`: web/app visit sessions with conversion flag.

### 2) Staging models (`models/staging`)
- Type casts, naming cleanup, and standardization.
- Keeps models close to source shape but analytics-ready.

### 3) Dimensional & Fact models (`models/marts`)
- `dim_users`: conformed user dimension (signup and first purchase attributes).
- `fact_transactions`: transactional grain with gross/refund/net revenue measures.
- `fact_sessions`: session grain with conversion/session duration features.

### 4) KPI models (`models/marts/kpis`)
- `kpi_revenue`: monthly gross/refund/net revenue and paying users.
- `kpi_conversion_rate`: monthly converted sessions / all sessions.
- `kpi_retention`: cohort-based retention by months since signup.

## KPI Definitions

### Revenue
**Definition:**
- `gross_revenue_usd`: sum of completed transaction amounts.
- `refunded_amount_usd`: sum of refunded transaction amounts.
- `net_revenue_usd`: gross - refunds.

**Model:** `kpi_revenue.sql`

### Conversion Rate
**Definition:**
- `conversion_rate = converted_sessions / total_sessions`
- Converted session is `is_conversion = 1`.

**Model:** `kpi_conversion_rate.sql`

### Retention
**Definition:**
- Users grouped by `cohort_month` (signup month).
- For each later month, retention is:
  `active_users_in_month / cohort_size`

**Model:** `kpi_retention.sql`

## How to run in dbt (example)

1. Configure your `profiles.yml` for your warehouse.
2. Load seed files as source tables (or place as dbt seeds in your own setup).
3. Run:

```bash
dbt seed
dbt run
dbt test
```

## Dashboarding Notes

A BI dashboard can directly consume KPI models:
- Trend cards: `kpi_revenue` net revenue MoM, `kpi_conversion_rate`.
- Retention heatmap: `kpi_retention` by `cohort_month` x `months_since_signup`.
- Slice/dice by dimensions: join facts to `dim_users` (channel, country, signup cohort).
