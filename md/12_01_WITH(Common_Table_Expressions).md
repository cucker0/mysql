WITH (Common Table Expressions)--公用表 表达式
==

## 公用表表达式是什么
Common Table Expressions，简单CTE，公用表表达式。

公用表表达式用于命名临时结果集（命名结果集为一个变量，方便重复引用），它的作用范围是该SQL语句内，

在该SQL语句中，可多次引用定义的公用表表达式。

## 公用表表达式语法
使用with分句来包含一个或多个 公用表表达式的子分句，

多个公用表表达式的子分句之间使用逗号分隔。

每个子分句提供一个子查询并生成一个结果集，并将一个名称分别与这些结果集关联。


* WITH分句格式
    ```sql
    WITH [RECURSIVE]
        cte_name [(col_name [, col_name] ...)] AS (subquery)
        [, cte_name [(col_name [, col_name] ...)] AS (subquery)] ...
    ```
    * col_name 定义的列名。
    * 位置SELECT之前。
    * 如果在subquery子查询中引用它自己的cte_name，则它是递归公用表表达式，需要指定RECURSIVE关键字。

* 示例
    ```mysql
    WITH 
        cte1 AS (SELECT a, b FROM table1),
        cte2 AS (SELECT  c, d FROM table2)
    SELECT b, d FROM cte1 CROSS JOIN cte2
    WHERE cte1.a = cte2.c
    ;
    ```

## 允许使用with分名的情形
*  SELECT, UPDATE,和 DELETE语句的开头
    ```sql
    WITH ... SELECT ...
    WITH ... UPDATE ...
    WITH ... DELETE ...
    ``` 
* 子查询(包括派生表的子查询)的开头
    ```sql
    SELECT ... WHERE id IN (WITH ... SELECT ...) ...
    SELECT * FROM (WITH ... SELECT ...) AS dt ...
    ```
* 包含SELECT声明语句的，with分句紧跟在`SELECT`前面
    ```sql
    INSERT ... WITH ... SELECT ...
    REPLACE ... WITH ... SELECT ...
    CREATE TABLE ... WITH ... SELECT ...
    CREATE VIEW ... WITH ... SELECT ...
    DECLARE CURSOR ... WITH ... SELECT ...
    EXPLAIN ... WITH ... SELECT ...
    ```
    
## 递归公用表达式
在公用表达式中有引用它自身。

* 递归公用表达式示例
    ```mysql
    WITH RECURSIVE cte (n) AS 
    (
        SELECT 1
        UNION ALL
        SELECT n + 1 FROM cte WHERE n < 5
    )
    SELECT * FROM cte;
    ```
    with分句必须包含`RECURSIVE`

* 递归SELECT子查询不得包含以下构造
    ```sql
    Aggregate functions such as SUM()
    
    Window functions
    
    GROUP BY
    
    ORDER BY
    
    DISTINCT
    ```