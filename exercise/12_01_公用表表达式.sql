# 12_01_公用表表达式


WITH cte (col1, col2) AS (
    SELECT 1, 2
    UNION ALL
    SELECT 3, 4
)
SELECT col1, col2 FROM cte;
/*
  col1    col2  
------  --------
     1         2
     3         4
*/

WITH cte AS (
    SELECT 1 AS col1, 2 AS col2
    UNION ALL
    SELECT 3, 4
)
SELECT col1, col2 FROM cte;
/*
  col1    col2  
------  --------
     1         2
     3         4
*/


## 递归公用表达式示例
WITH RECURSIVE cte (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 5
)
SELECT * FROM cte
;
/*
     n  
--------
       1
       2
       3
       4
       5
*/

-- 递归公用表表达式 示例2
WITH RECURSIVE c AS (
    SELECT 1 AS n, 'abc' AS str
    UNION ALL
    SELECT n + 1, CONCAT(str, str) FROM c WHERE n < 3
)
SELECT n FROM c;

-- 严格模式下报错
/*
错误代码： 1406
Data too long for column 'str' at row 1
*/

-- 非严格模式下
/*
+------+------+
| n    | str  |
+------+------+
|    1 | abc  |
|    2 | abc  |
|    3 | abc  |
+------+------+

str列值都是"abc"，因为非递归选择决定了列宽。因此，递归SELECT生成的较宽str值被截断。
*/

WITH RECURSIVE cte AS (
    SELECT 1 AS n, CAST('abc' AS CHAR(20)) AS str
    UNION ALL
    SELECT n + 1, CONCAT(str, str)FROM cte WHERE n < 3
)
SELECT * FROM cte;
/*
     n  str           
------  --------------
     1  abc           
     2  abcabc        
     3  abcabcabcabc  
*/

WITH RECURSIVE cte AS (
    SELECT 1 AS n, 1 AS p, -1 AS q
    UNION ALL
    SELECT n +1, p * 2, q * 2 FROM cte WHERE n < 5
)
SELECT * FROM cte;
/*
     n       p       q  
------  ------  --------
     1       1        -1
     2       2        -2
     3       4        -4
     4       8        -8
     5      16       -16
*/

