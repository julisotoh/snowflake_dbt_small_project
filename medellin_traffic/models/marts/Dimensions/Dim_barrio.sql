-- dtb/models/stg/stg_personas.sql
{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}


select distinct
CASE
        WHEN REGEXP_LIKE(a.barrio, '^[0-9]+$')
            THEN 'codigo'

        WHEN UPPER(a.barrio) ILIKE 'SUBURBANO'
            THEN 'SUBURBANO'

        WHEN UPPER(a.barrio) IN ('0', 'SIN NOMBRE', 'SIN INF')
            THEN 'DESCONOCIDO'

        ELSE 'BARRIO'
        END AS tipo_barrio,
REPLACE(a.barrio, 'SUBURBANO', '') as barrio,
case when comuna = 'SIN INF' then'000' ELSE SPLIT_PART(comuna, '-', 1) 
END AS codigo_comuna ,
{{ audit_columns() }}
from {{ ref('stg_victimas_incidente') }} as a 
inner join {{ ref('stg_incidentes_medellin') }} as b 
on a.BARRIO = b.BARRIO



