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


## 限制公用表表达式的递归
--  cte_max_recursion_depth
SELECT @@cte_max_recursion_depth;  -- 默认值为1000

SET SESSION cte_max_recursion_depth = 10;  -- 设置当前会话的公用表表达式的最大递归层级深度为10


-- 示例
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte
)
SELECT * FROM cte;
/*
错误代码： 3636
Recursive query aborted after 1001 iterations. Try increasing @@cte_max_recursion_depth to a larger value.
*/

-- 提示优化器最大的cte_max_recursion_depth的值
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte
)
SELECT /*+ SET_VAR(cte_max_recursion_depth = 1M) */ * FROM cte;
/*
错误代码： 3636
Recursive query aborted after 1048577 iterations. Try increasing @@cte_max_recursion_depth to a larger value.
*/

-- max_execution_time
SELECT @@max_execution_time;  -- 默认值为0，表示不限制时间

SET @@max_execution_time = 1000  -- 单位为：ms。当前值表示 1000ms，即1秒


-- 
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte LIMIT 10000
)
SELECT * FROM cte;

-- 提示优化器最大的MAX_EXECUTION_TIME的值
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte
)
SELECT /*+ MAX_EXECUTION_TIME(1000) */ * FROM cte;


-- LIMIT 限制公用表表达的递归
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte LIMIT 12
)
SELECT * FROM cte;


## 递归公用表表达式的示例
-- 分层查看数据
-- 示例：查看员工的层级关系

-- 准备数据
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    manager_id INT NULL,

    INDEX (manager_id),
    FOREIGN KEY (manager_id) REFERENCES employees (id)
);

INSERT INTO employees VALUES
(333, "Yasmina", NULL),  # Yasmina is the CEO (manager_id is NULL)
(198, "John", 333),      # John has ID 198 and reports to 333 (Yasmina)
(692, "Tarek", 333),
(29, "Pedro", 198),
(4610, "Sarah", 29),
(72, "Pierre", 29),
(123, "Adil", 692);

SELECT * FROM employees;

-- 查看员工的层级关系
WITH RECURSIVE emp_paths (id, `name`, `path`) AS (
    SELECT id, `name`, CAST(id AS CHAR(200))
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.id, e.name, CONCAT(ep.path, ',', e.id)
    FROM emp_paths AS ep
    INNER JOIN employees AS e
    ON ep.id = e.manager_id
)
SELECT * FROM emp_paths ORDER BY `path`;
/*
    id  name     path             
------  -------  -----------------
   333  Yasmina  333              
   198  John     333,198          
    29  Pedro    333,198,29       
  4610  Sarah    333,198,29,4610  
    72  Pierre   333,198,29,72    
   692  Tarek    333,692          
   123  Adil     333,692,123      
*/
