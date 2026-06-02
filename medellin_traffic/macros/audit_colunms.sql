{% macro audit_columns() %}

    TO_CHAR(CURRENT_TIMESTAMP(), 'YYYY-MM-DD HH24:MI:SS') AS created_dt,
    TO_CHAR(CURRENT_TIMESTAMP(), 'YYYY-MM-DD HH24:MI:SS') AS updated_dt

{% endmacro %}