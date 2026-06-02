{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}

    SELECT a.cbml,a.direccion,a.diseno,a.expediente,a.gravedad_accidente,a.nro_radicado,a.eje_x,a.eje_y,a.location,
    c.barrio, c.tipo_barrio, d.tipo_accidente , e.fecha, e.anio, e.mes,e.dia, e.tipo_dia,e.dia_semana
    from  {{ ref('stg_incidentes_medellin') }} as  a 
    inner join   {{ ref('stg_victimas_incidente') }} as b on  a.nro_radicado = b.RADICADO
    inner join {{ ref('Dim_barrio') }} as c on c.barrio = a.barrio
    inner join {{ ref('dim_tipo_accidente') }} as  d on d.tipo_accidente = a.tipo_accidente
    INNER JOIN {{ ref('Dim_fecha_accidente') }} as e on e.fecha = a.fecha_incidente

   