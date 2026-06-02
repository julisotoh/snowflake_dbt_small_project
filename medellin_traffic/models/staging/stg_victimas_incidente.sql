{{
    config(
        materialized='table',
    )
}}


SELECT 
    UPPER(gravedad_victima) AS gravedad_victima,
    fecha_incidente, 
    hora_incidente,
    UPPER(clase_incidente) AS clase_incidente,
    UPPER(direccion_incidente) AS direccion_incidente,
    UPPER(sexo) AS sexo, 
    edad,
    UPPER(condicion) AS condicion,
    UPPER(mes) AS mes,
    UPPER(dia) AS dia,
    num_dia,
    hora,
    grupo_edad,
    ano,
    radicado,
    latitud,
    longitud,
    UPPER(comuna) AS comuna,
    UPPER(barrio) AS barrio,
     {{ audit_columns() }}
from {{source('raw','raw_victimas_incidentes_med')}}