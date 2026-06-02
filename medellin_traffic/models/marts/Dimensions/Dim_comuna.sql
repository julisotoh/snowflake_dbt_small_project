-- dtb/models/stg/stg_personas.sql
{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}

select distinct
case when comuna = 'SIN INF' then'000' ELSE SPLIT_PART(comuna, '-', 1) END AS codigo_comuna ,
case when comuna = 'SIN INF' then'SIN INFORMACION' ELSE SPLIT_PART(comuna, '-', 2) END AS comuna_desc,
{{ audit_columns() }}
from {{ ref('stg_victimas_incidente') }}
