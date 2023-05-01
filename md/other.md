其他
==

## CTE--公用表表达式
[参考](https://dev.mysql.com/doc/refman/8.0/en/with.html)

CTE：WITH (Common Table Expressions)

公共表表达式（CTE）是一个命名的临时结果集，存在于单个语句的范围内，以后可以在该语句中引用，可能多次引用。

### CTE语法
```mysql
WITH [RECURSIVE]
    cte_name [(col_name [, col_name] ...)] AS (subquery)
    [, cte_name [(col_name [, col_name] ...)] AS (subquery)] ...
```

* 示例1
    ```mysql
    WITH
        cte1 AS (SELECT a, b FROM table1),
        cte2 AS (SELECT c, d FROM table2)
    SELECT b, d FROM cte1 JOIN cte2
    WHERE cte1.a = cte2.c;
    ```

* 示例2
    ```mysql
    WITH cte (col1, col2) AS
    (
        SELECT 1, 2
        UNION ALL
        SELECT 3, 4
    )
    SELECT col1, col2 FROM cte;
    ```

* 示例3
    ```mysql
    WITH cte AS
    (
        SELECT 1 AS col1, 2 AS col2
        UNION ALL
        SELECT 3, 4
    )
    SELECT col1, col2 FROM cte;
    ```