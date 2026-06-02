-- dtb/models/stg/stg_personas.sql
{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}


SELECT DISTINCT

    TRY_TO_DATE(fecha_accidente) AS fecha,

    YEAR(TRY_TO_DATE(fecha_accidente)) AS anio,

    MONTH(TRY_TO_DATE(fecha_accidente)) AS mes,

    DAY(TRY_TO_DATE(fecha_accidente)) AS dia,

    DAYNAME(TRY_TO_DATE(fecha_accidente)) AS dia_semana,

    CASE
        WHEN DAYOFWEEK(TRY_TO_DATE(fecha_accidente)) IN (1,7)
        THEN 'FIN_SEMANA'
        ELSE 'SEMANA'
    END AS tipo_dia

FROM  {{ ref('stg_incidentes_medellin') }}