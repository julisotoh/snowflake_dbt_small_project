# CLUSTER BY

is used to tell Snowflake how to organize the data.

It is similar to an index in traditional databases, but instead of creating an index structure, Snowflake organizes the data using micro-partitions.

Example:

```sql
ALTER TABLE DDS.FACT_INCIDENTES
    CLUSTER BY (ANIO, GRAVEDAD_ACCIDENTE);
```

In this example, Snowflake organizes the table based on ANIO and GRAVEDAD_ACCIDENTE, which can improve query performance when filtering on those columns.

CLUSTER BY is mostly used in the DDS layer, especially for Fact and Dimension tables. In the STAGING (or Silver) layer, it is usually only needed when the table becomes very large.



# Result Cache

If you run the same query twice and the underlying data has not changed, Snowflake returns the stored result instead of executing the query again.

To disable the cache:

```sql
ALTER SESSION SET USE_CACHED_RESULT = FALSE;
```

Disabling the cache is useful when testing query performance because it forces Snowflake to execute the query again.

This allows you to compare query performance before and after applying a `CLUSTER BY`.

For example:

### Before CLUSTER BY


Partitions Scanned: 1
Partitions Total:   2


### After CLUSTER BY (with cache disabled)


Partitions Scanned: 1
Partitions Total:   1


Using the Query Profile, we can verify whether clustering improved partition pruning and reduced the amount of data scanned.

