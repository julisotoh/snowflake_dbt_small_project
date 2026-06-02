{{ config(
    materialized='incremental',
    unique_key='radicado'       
) }}

SELECT
    radicado,
    fecha_incidente, 
    hora_incidente,
     gravedad_victima, 
     clase_incidente,
      sexo, 
      edad, 
      condicion,
       barrio
FROM {{ ref('stg_victimas_incidente') }}

{% if is_incremental() %}
WHERE FECHA_INCIDENTE > (SELECT MAX(FECHA_INCIDENTE) FROM {{ this }})
{% endif %}