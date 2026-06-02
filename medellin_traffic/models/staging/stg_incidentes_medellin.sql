{{
    config(
        materialized='table',
    )
}}

with source_raw as (
   SELECT ano,
       cbml,
       CASE
        WHEN CLASE_ACCIDENTE IN (
            'Caida de Ocupante',
            'Caida Ocupante',
            'Caída de Ocupante',
            'Caída Ocupante'
        )
        THEN 'Caída de Ocupante'

        WHEN LOWER(CLASE_ACCIDENTE) = 'choque'
        THEN 'Choque'

        WHEN LOWER(CLASE_ACCIDENTE) = 'atropello'
        THEN 'Atropello'

        ELSE INITCAP(CLASE_ACCIDENTE)
    END AS tipo_accidente,
        direccion,
        direccion_encasillada,
        diseno,
        expediente,
        REPLACE(fecha_accidente, 'Sin Inf', '') as fecha_accidente,
        TO_CHAR(FECHA_ACCIDENTES,'YYYY-MM-DD') as fecha_incidente,
        hour(FECHA_ACCIDENTES) as hora,
        minute(FECHA_ACCIDENTES) as minutos,
        second(FECHA_ACCIDENTES) as segundos,
        gravedad_accidente,
        mes,
        nro_radicado,
        numcomuna,
        barrio,
        location,
        x as eje_x,
        y as eje_y
    FROM {{source('raw','raw_incidentes_medellin')}}
)

select 
        ano,
        cbml,
        upper(tipo_accidente) as tipo_accidente,
        upper(direccion) as direccion,
        upper(direccion_encasillada) as direccion_encasillada,
        upper(diseno) as diseno,
        upper(expediente) as expediente,
        fecha_accidente,
        fecha_incidente,
        hora,
        minutos,
        segundos,
        upper(gravedad_accidente) as gravedad_accidente,
        mes,
        nro_radicado,
        numcomuna,
        TRIM(upper(barrio)) as barrio,  
        location,
        eje_x,
        eje_y,
        {{ audit_columns() }}
 from source_raw
