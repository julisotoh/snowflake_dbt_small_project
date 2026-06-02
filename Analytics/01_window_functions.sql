--Exercise 1: 

--Total incidents per neighborhood for a specific year

--Requirement:
--Show all incidents for a specific year. Each row should display:

--Date (FECHA)
--Neighborhood (BARRIO)
--Accident severity (GRAVEDAD_ACCIDENTE)
--Total number of incidents in that neighborhood during the selected year

SELECT FECHA,
        BARRIO,
        GRAVEDAD_ACCIDENTE,
        COUNT(*) OVER(PARTITION BY BARRIO) AS TOTAL_INC_BARRIO
FROM DDS.FACT_INCIDENTES
WHERE ANIO =2020
ORDER BY BARRIO, FECHA


--Exercise 2: 

--Top 3 neighborhoods with the highest number of incidents per year


--Requirement:

--For each year, identify the three neighborhoods with the highest number of incidents.
--The result should include:
--Year (ANIO)
--Neighborhood (BARRIO)
--Total incidents
--Ranking within the year

 SELECT ANIO,
        BARRIO,
        COUNT(*) as total,
        RANK() OVER(PARTITION BY ANIO ORDER BY COUNT(*) DESC) AS TOTAL_INC_ANO
FROM DDS.FACT_INCIDENTES
GROUP BY ANIO,barrio
QUALIFY TOTAL_INC_ANO <= 3
order by ANIO,barrio


--Exercise 3: 

--Monthly Incident Trend Analysis

--Requirement-
--how many incidents there were per month and year, the total for the previous month, and the difference between the two periods. 
--Each row should include:
--Year (ANIO)
--Month (MES)
--Total incidents
--Total incidents from the previous month
--Difference between the current month and the previous month
--Results should be ordered by year and month.

SELECT
    ANIO,
    MES,
    COUNT(*) AS TOTAL_INC,
    LAG(COUNT(*)) OVER (ORDER BY ANIO, MES) AS PREVIOUS_MONTH_TOTAL,
    COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY ANIO, MES) AS DIFFERENCE
FROM DDS.FACT_INCIDENTES
GROUP BY ANIO, MES
ORDER BY ANIO, MES;


--Exercise 4:
  
 --Top 3 Neighborhoods by Year with Historical Comparison

Requirement
--show the 3 neighborhoods with the most incidents per year, and for each one show how many incidents 
--that neighborhood had the previous year and the difference.
--Neighborhood (BARRIO)
--Year (ANIO)
--Total incidents
--Ranking within the year
--Difference compared to the previous year's incident count for the same neighborhood

SELECT
    BARRIO,
    ANIO,
    COUNT(*) AS TOTAL_INC,
    RANK() OVER(PARTITION BY ANIO ORDER BY COUNT(*) DESC) AS POSITION,
    COUNT(*) - LAG(COUNT(*)) OVER (
        PARTITION BY BARRIO
        ORDER BY ANIO
    ) AS DIFFERENCE
FROM DDS.FACT_INCIDENTES
GROUP BY BARRIO, ANIO
QUALIFY POSITION <= 3
ORDER BY BARRIO, ANIO;



--Exercise 5: 

--Combined Window Functions Analysis

--Requirement
--For each neighborhood and year, display:
--Total incidents
--Neighborhood ranking within the year (Top 3)
--Running cumulative incidents by month within the same neighborhood and year
--Percentage change compared to the previous period for the same neighborhood
--Protection against division-by-zero errors


WITH base AS (
    SELECT
        BARRIO,
        ANIO,
        MES,
        COUNT(*) AS TOTAL_INC
    FROM DDS.FACT_INCIDENTES
    GROUP BY BARRIO, ANIO, MES
),

final AS (
    SELECT
        BARRIO,
        ANIO,
        MES,
        TOTAL_INC,

        RANK() OVER (
            PARTITION BY ANIO
            ORDER BY TOTAL_INC DESC
        ) AS POSITION,

        SUM(TOTAL_INC) OVER (
            PARTITION BY BARRIO, ANIO
            ORDER BY MES
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS CUMULATIVE_TOTAL,

        ROUND(
            (
                TOTAL_INC
                - LAG(TOTAL_INC) OVER (
                    PARTITION BY BARRIO
                    ORDER BY ANIO, MES
                )
            ) * 100.0
            /
            NULLIF(
                LAG(TOTAL_INC) OVER (
                    PARTITION BY BARRIO
                    ORDER BY ANIO, MES
                ),
                0
            ),
            2
        ) AS PCT_CHANGE

    FROM base
)

SELECT *
FROM final
QUALIFY POSITION <= 3
ORDER BY ANIO, POSITION, MES;