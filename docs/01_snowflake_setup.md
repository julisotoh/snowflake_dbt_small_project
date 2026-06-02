# Snowflake Setup

## 1. Create a Warehouse

A warehouse is the compute engine used to execute queries in Snowflake.

It is a best practice to create separate warehouses for each environment (Development, Staging, and Production), since compute requirements and workloads usually differ across environments.

Warehouses can be created either using SQL commands or directly from the 
**Compute → Warehouses** section in the Snowflake UI.

```sql
CREATE OR REPLACE WAREHOUSE TRAFFIC_WH_DEV
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;
```

### Configuration

* **WAREHOUSE_SIZE**: Defines the compute capacity of the warehouse.
* **AUTO_SUSPEND = 60**: Suspends the warehouse after 60 seconds of inactivity to reduce costs.
* **AUTO_RESUME = TRUE**: Automatically resumes the warehouse when a query is executed.
* **INITIALLY_SUSPENDED = TRUE**: Creates the warehouse in a suspended state.

---

## 2. Create the Database and Schemas

After creating the warehouse, create the project database and the schemas.

```sql
USE WAREHOUSE TRAFFIC_WH_DEV;

CREATE OR REPLACE DATABASE MEDELLIN_MOBILITY;

CREATE OR REPLACE SCHEMA RAW;
CREATE OR REPLACE SCHEMA STAGING;
CREATE OR REPLACE SCHEMA DDS;
```

### Schema Description

RAW: Stores the original source data without transformations.  
STAGING:Contains cleaned and standardized data used for transformations.
DDS: Dimensional Data Store layer containing fact and dimension tables for analytics.


# upload the data in snowflake

There are multiple ways to load data into Snowflake, including ETL/ELT tools such as Fivetran, Airbyte, Informatica, Matillion, or custom ingestion pipelines.

For the purpose of this project, I decided to load the raw CSV files directly into Snowflake interface using the ingestion option.

This approach keeps the architecture simple while allowing the focus to remain on data modeling, transformations, and analytics

**steps**
Navigation path:
Ingestion->Load Data into Table
