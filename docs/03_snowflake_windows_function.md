# Windows Fuctions 

Window functions are analytical functions used to calculate totals, rankings, comparisons between rows, running totals, and other metrics


# RANK: 

assigns a position to each row based on a specified ordering.

When multiple rows have the same value, they receive the same rank, and the next rank is skipped.

Example: 
the best cities around the world are :

-------------------------------------------------
    city.        |      score   |    Position
-------------------------------------------------
Melbourne        |        10    |       1
Shanghai         |        10    |       2
Edinburgh        |        8     |       3
London           |        8     |       4
New York         |        7     |       5
Cape Town        |        7     |       6



Applying RANK():


------------------------------------------------------
    city.        |      score       |       Rank 
------------------------------------------------------
Melbourne        |        10        |        1
Shanghai         |        10        |        1
Edinburgh        |        8         |        3
London           |        8         |        3
New York         |        7         |        5
Cape Town        |        7         |        5

```sql
 SELECT ANIO,
        BARRIO,
        COUNT(*) as total,
        RANK() OVER(PARTITION BY ANIO ORDER BY COUNT(*) DESC) AS TOTAL_INC_ANO
FROM DDS.FACT_INCIDENTES
GROUP BY ANIO,barrio
QUALIFY TOTAL_INC_ANO <= 3
order by ANIO,barrio

```

# QUALIFY

After RANK() assigns a position to each row, QUALIFY helps filter the rows you want to keep in the final result

QUALIFY can also be used with other window functions such as ROW_NUMBER(), DENSE_RANK(), LAG(), LEAD(), and many others.

# OVER(PARTITION BY)

Whenever you need a group total next to the detailed records.

A GROUP BY returns only the aggregated result and removes the detail.

 With a window function, you can keep every row while also showing totals, averages, counts, and other calculations at the group level.

 # LAG - LEAD 

 LAG() and LEAD() are window functions used to compare a row with a previous or next row.

        LAG() looks backward.
        LEAD() looks forward.

----------------------------------------------------------------
Month	  |     Incidents  |	Previous Month	|   Difference
----------------------------------------------------------------
January     	100	                NULL	           NULL
February	    120	                100	               20
March	        90	                120	              -30

