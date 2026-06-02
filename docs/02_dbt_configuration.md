# dbt Configuration

## 1. Initialize the dbt Project

Create a new dbt project:

```bash
dbt init medellin_traffic
```

## 2. Environment Variables

 `.env` file:

```bash
SNOWFLAKE_ACCOUNT=YOUR_ACCOUNT
SNOWFLAKE_USER=YOUR_USER
SNOWFLAKE_PASSWORD=YOUR_PASSWORD
SNOWFLAKE_ROLE=SYSADMIN
SNOWFLAKE_WAREHOUSE=YOUR_WAREHOUSE
SNOWFLAKE_DATABASE=YOUR_DATABASE
SNOWFLAKE_SCHEMA=YOUR_SCHEMA
```

The `.env` file helps keep sensitive information, such as usernames and passwords, out of the source code and prevents credentials from being exposed when pushing the project to GitHub.

This command loads all environment variables from the `.env` file into the current terminal session.

```bash
export $(grep -v '^#' .env | xargs)
```


* Note: Make sure to add `.env` to `.gitignore` file to avoid accidentally committing credentials to the repository.

## 3. Configure Models

To keep the project organized, configure different schemas for each layer of the architecture.

In `dbt_project.yml`:

```yaml
models:
  medellin_traffic:

    staging:
      +schema: STAGING
      +materialized: table

    marts:
      +schema: DDS
      +materialized: table
```

This configuration ensures that:

* Models inside the `staging` folder are created in the STAGING schema.
* Models inside the `marts` folder are created in the DDS schema.
* All models are materialized as tables,  dbt allows different materialization strategies such as table, view, incremental, and ephemeral, depending of the business



## 4. Configure the dbt Profile

The `profiles.yml` file defines the connection between dbt and Snowflake.

A standard profile configuration looks like this:

```yaml
medellin_traffic:
  target: dev

  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT
      user: YOUR_USER
      password: YOUR_PASSWORD
      role: SYSADMIN
      database: YOUR_DATABASE
      warehouse: YOUR_WAREHOUSE
      schema: YOUR_SCHEMA
```

For improved security, credentials should be stored as environment variables instead of hardcoding them.

Example:

```yaml
outputs:
  dev:
    type: snowflake
    account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
    user: "{{ env_var('SNOWFLAKE_USER') }}"
    password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
    role: "{{ env_var('SNOWFLAKE_ROLE') }}"
    database: "{{ env_var('SNOWFLAKE_DATABASE') }}"
    warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"
    schema: "{{ env_var('SNOWFLAKE_SCHEMA') }}"
    threads: 4
    client_session_keep_alive: False
```




## 5. Custom Schema Generation

The schema defined in profiles.yml is used as the default target schema for dbt models.
In this project, different layers must be deployed to separate Snowflake schemas:

    STAGING models → STAGING schema
    MARTS models → DDS schema

To ensure models are created in the correct schemas, a custom macro named generate_schema_name.sql is implemented.

macros/generate_schema_name.sql

```bash
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}

```

This macro overrides dbt's default schema generation behavior and ensures that models are created directly in the schemas defined in dbt_project.yml.

```bash
models:
  medellin_traffic:

    staging:
      +schema: STAGING
      +materialized: table

    marts:
      +schema: DDS
      +materialized: table

      Dimensions:
        +tags: ['dimensions']

      Facts:
        +tags: ['facts']
```

As a result, staging models are deployed to the STAGING schema and dimensional models are deployed to the DDS schema, maintaining a clean separation between architectural layers.