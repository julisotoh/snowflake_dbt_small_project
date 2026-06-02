Medellín Traffic Analytics — Snowflake + dbt

End-to-end Data Engineering project built with Snowflake and dbt using open traffic incident data from Medellín.

Data Source
Traffic Incidents Dataset from Medellín Open Data Portal.
--https://www.datos.gov.co/dataset/Incidentes-viales/9wqu-juqb/about_data
--https://medata.gov.co/node/16692




 Tech Stack
--Snowflake
--dbt
--SQL


-- Architecture

Raw Data(datasets from Medellin goverment page)
        ↓
   Snowflake Stage (CSV)
        ↓
   RAW Layer        ← raw tables, no transformations
        ↓
   STAGING Layer    ← cleaning, typing (dbt)
        ↓
   DDS Layer        ← dimensional model: Facts + Dims (dbt)
        ↓
   Analytics        ← window functions



---Features
Snowflake Data Warehouse
dbt transformations
Star Schema modeling
Window Functions
Dynamic Tables
Time Travel
Zero Copy Clone
Streams & Tasks



-- How to Run

-- Prerequisites
-- Snowflake account (free trial)
-- dbt Core installed (pip install dbt-snowflake)
--https://www.datos.gov.co/dataset/Incidentes-viales/9wqu-juqb/about_data
--https://medata.gov.co/node/16692



