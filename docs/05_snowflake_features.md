# Dynamic Tables

Dynamic Tables are incremental tables managed by Snowflake.

They work similarly to a materialized view, but instead of reading and rebuilding the entire dataset every time, they process only the new or changed data.

The refresh frequency is controlled through `TARGET_LAG`, which defines how up to date the table should be.

For example:

* Every 5 minutes
* Every 15 minutes
* Every hour

Example:

```sql
CREATE DYNAMIC TABLE RESUMEN_DIARIO
TARGET_LAG = '1 hour'
WAREHOUSE = COMPUTE_WH
AS
SELECT
    FECHA,
    BARRIO,
    COUNT(*) AS TOTAL
FROM FACT_INCIDENTES
GROUP BY FECHA, BARRIO;
```


# Time Travel

Time Travel allows you to access historical versions of your data and recover information after accidental changes.

Think of it as a way to see how a table looked at a previous point in time.



### 1. Using OFFSET

Show the table as it existed 5 minutes ago:

```sql
SELECT *
FROM FACT_INCIDENTES
AT (OFFSET => -60 * 5);
```

### 2. Using  Query ID

Show the table before a specific query was executed:

```sql
SELECT *
FROM FACT_INCIDENTES
BEFORE (STATEMENT => 'query_id_here');
```

### 3. Using a Timestamp

Show the table at an exact moment:

```sql
SELECT *
FROM FACT_INCIDENTES
AT (TIMESTAMP => '2024-01-15 09:00:00'::TIMESTAMP);
```

---

## Example: Recovering a Deleted Dataset

Before deletion:

```sql
SELECT COUNT(*) FROM DDS.FACT_INCIDENTES;
-- 79,537

SELECT COUNT(*) FROM DDS.FACT_INCIDENTES
WHERE ANIO = 2020;
-- 4,640
```

Accidental delete:

```sql
DELETE FROM DDS.FACT_INCIDENTES
WHERE ANIO = 2020;
```

Recover the table using Time Travel:

```sql
CREATE OR REPLACE TABLE DDS.FACT_INCIDENTES AS
SELECT *
FROM DDS.FACT_INCIDENTES
BEFORE (STATEMENT => LAST_QUERY_ID());
```

If needed, a specific query ID can also be used.



# Zero Copy Clone

Zero Copy Clone is similar to a `CREATE TABLE AS SELECT`, but it is much faster and requires significantly less storage.


Example:

```sql
CREATE TABLE DDS.FACT_INCIDENTES_DEV
CLONE DDS.FACT_INCIDENTES;
```



# Streams and Tasks

A Stream show what has changed in a table since the last time it was consumed.


