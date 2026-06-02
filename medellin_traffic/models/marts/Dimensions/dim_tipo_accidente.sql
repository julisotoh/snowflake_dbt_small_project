-- dtb/models/stg/stg_personas.sql
{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}


SELECT

    ROW_NUMBER() OVER (ORDER BY tipo_accidente) AS tipo_accidente_id,

    tipo_accidente

FROM (

    SELECT DISTINCT
        tipo_accidente

    FROM  {{ ref('stg_incidentes_medellin') }}

)