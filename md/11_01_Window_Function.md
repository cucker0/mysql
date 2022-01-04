Window Function窗口函数
==

参考 https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html

https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html

## 窗口函数是什么
窗口函数对查询结果集做类似聚合函数的操作，  
但聚合函数将结果集的多行数据处理后只返回一个值（只有一行），  
而窗口函数则把处理后得出的结果作为一个字段 加到前面处理的查询结果集的每一行上

### 聚合函数做窗口操作
聚合函数是否当作窗口操作取决于是否有OVER()子句。

```sql
AVG()
BIT_AND()
BIT_OR()
BIT_XOR()
COUNT()
JSON_ARRAYAGG()
JSON_OBJECTAGG()
MAX()
MIN()
STDDEV_POP(), STDDEV(), STD()
STDDEV_SAMP()
SUM()
VAR_POP(), VARIANCE()
VAR_SAMP()
```

**示例**
```mysql
-- 准备数据
CREATE DATABASE window_func;

USE window_func;

CREATE TABLE sales (
    `year` YEAR,
    country VARCHAR(32),
    product VARCHAR(32) NOT NULL,
    profit INT COMMENT '利润'
);


INSERT INTO sales (`year`, country, product, profit) VALUES
('2000', 'Finland', 'Computer', 1500),
('2000', 'Finland', 'Phone', 100),
('2000', 'India', 'Calculator', 75),
('2000', 'India', 'Calculator', 75),
('2000', 'India', 'Computer', 1200),
('2000', 'USA', 'Calculator', 75),
('2000', 'USA', 'Computer', 1500),
('2001', 'Finland', 'Phone', 10),
('2001', 'USA', 'Calculator', 50),
('2001', 'USA', 'Computer', 1500),
('2001', 'USA', 'Computer', 1200),
('2001', 'USA', 'TV', 150),
('2001', 'USA', 'TV', 100)
;
```

* SUM()聚合操作
    ```mysql
    ## SUM()聚合函数做窗口操作效果
    -- 总利润
    SELECT SUM(profit) AS total_profit 
    FROM sales;
    /*
    total_profit  
    --------------
              7535
    */
    
    -- 每个国家的总利润
    SELECT country, SUM(profit) AS country_profit
    FROM sales
    GROUP BY country;
    /*
    country  country_profit  
    -------  ----------------
    Finland              1610
    India                1350
    USA                  4575
    */
    ```
* SUM做窗口操作
    ```mysql
    ## 窗口操作效果
    SELECT 
        `year`,
        country,
        product,
        profit,
        SUM(profit) OVER() AS total_profit,
        SUM(profit) OVER (PARTITION BY country) AS country_profit
    FROM sales
    ORDER BY country, `year`, product, profit;
    /*
      year  country  product     profit  total_profit  country_profit  
    ------  -------  ----------  ------  ------------  ----------------
      2000  Finland  Computer      1500          7535              1610
      2000  Finland  Phone          100          7535              1610
      2001  Finland  Phone           10          7535              1610
      2000  India    Calculator      75          7535              1350
      2000  India    Calculator      75          7535              1350
      2000  India    Computer      1200          7535              1350
      2000  USA      Calculator      75          7535              4575
      2000  USA      Computer      1500          7535              4575
      2001  USA      Calculator      50          7535              4575
      2001  USA      Computer      1200          7535              4575
      2001  USA      Computer      1500          7535              4575
      2001  USA      TV             100          7535              4575
      2001  USA      TV             150          7535              4575
    */
    ```
    
## 窗口函数列表

<table>
<thead>
    <tr>
        <th>函数分类</th>
        <th>函数</th>
        <th>描述</th>
    </tr>
</thead>

<tbody>
    <tr>
        <td rowspan="3">序号函数</td>
        <td>ROW_NUMBER()</td>
        <td>给当前分区内的所有行顺序编号。1, 2, 3...</td>
    </tr>
    <tr>
        <td>RANK()</td>
        <td>对ORDER BY 字段排名，当前行在其分区内的排名，有间隙。值相同的的并列排名，会跳过重复的序号，如1,1,3</td>
    </tr>
    <tr>
        <td>DENSE_RANK()</td>
        <td>对ORDER BY 字段排名，当前行在其分区内的排名，没有间隙（密集排名）。值相同的的并列排名，不会跳过重复的序号，如1,1,2</td>
    </tr>
    <tr>
        <td rowspan="2">分布函数</td>
        <td>PERCENT_RANK()</td>
        <td>等级值百分比.<br>返回小于当前行中的值（不包括最高值）的分区值百分比。返回值的范围：[0, 1]，表示行的相对排名</td>
    </tr>
    <tr>
        <td>CUME_DIST()</td>
        <td>累计分布值</td>
    </tr>
    <tr>
        <td rowspan="2">前后函数</td>
        <td>LAG(expr [, N[, default]])</td>
        <td>返回当前行的前N行的expr值</td>
    </tr>
    <tr>
        <td>LEAD(expr [, N[, default]])</td>
        <td>返回当前行的后N行的expr值</td>
    </tr>
    <tr>
        <td rowspan="2">首尾函数</td>
        <td>FIRST_VALUE(expr)</td>
        <td>返回第一行的expr值</td>
    </tr>
    <tr>
        <td>LAST_VALUE(expr)</td>
        <td>返回最后一行的expr值</td>
    </tr>
    <tr>
        <td rowspan="2">其他函数</td>
        <td>NTH_VALUE(expr, N)</td>
        <td>返回第N行的expr值</td>
    </tr>
    <tr>
        <td>NTILE(N)</td>
        <td>将分区中的有序数据分为N个桶，给桶编上序号</td>
    </tr>
</tbody>
</table>


### 窗口操作的over_clause语法
OVER 子句

窗口操作的语法
```sql
SELECT 
    function(expr) over_clause as alias_name
FROM <table_name>
```

* over_clause 有两种格式
```sql
{OVER (window_spec) | OVER window_name}
```

* window_spec格式
    ```sql
    [window_name] [partition_clause] [order_clause] [frame_clause]
    ```

    OVER() 表示所有行。
* partition_clause语法
    ```sql
    PARTITION BY expr [, expr] ...
    ```

* order_clause语法
    ```sql
    ORDER BY expr [ASC|DESC] [, expr [ASC|DESC]] ...
    ```
    
* frame_clause语法
    ```sql
    frame_units frame_extent
    
    
    frame_units:
        {ROWS | RANGE}
        
    frame_extent:
        {frame_start | frame_between}
    
    frame_between:
        BETWEEN frame_start AND frame_end
    
    frame_start, frame_end: {
        CURRENT ROW
      | UNBOUNDED PRECEDING
      | UNBOUNDED FOLLOWING
      | expr PRECEDING
      | expr FOLLOWING
    } 
    ```
    frame_clause子句缺省的情况下为：`ROWS CURRENT ROW`，即window frame从第一行 到 当前行。
    
* **设置window_name变量**
    ```sql
    WINDOW w AS (window_spec)
    ```
    windows变量可以被OVER引用。


### PERCENT_RANK()
返回小于当前行中的值（不包括最高值）的分区值百分比。返回值的范围：[0, 1]，表示行的相对排名

* 计算公式
    ```sql
    (rank - 1) / (rows - 1)
    ```
    rank  行的排名，RANK()函数产生的排名。
    rows  该分区内的总行数

### CUME_DIST()
返回一组值内的累计分布值。即分区值小于或等于当前行中的值的百分比。

### LAG()
* 语法
    ```sql
    LAG(expr [, N[, default]]) [null_treatment] over_clause
    ```
    
### LEAD()
* 语法
    ```sql
    LEAD(expr [, N[, default]]) [null_treatment] over_clause
    ```

### FIRST_VALUE(expr)
Returns the value of expr from the first row of the window frame.
返回当前window frame内的的第一行中的expr值。即分区内的第一行的expr值。

* 语法
    ```sql
    FIRST_VALUE(expr) [null_treatment] over_clause
    ```

### LAST_VALUE(expr)
Returns the value of expr from the last row of the window frame.
返回当前window frame内的最后一行的expr值。frame子句缺省的情况下，就是当前行的 expr，不是分区内的最后一行。

要去分区内的最后一行，可添加frame子句
```sql
ORDER BY expr 
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

* 语法
    ```sql
    LAST_VALUE(expr) [null_treatment] over_clause
    ```

### NTH_VALUE(expr, N)
返回windows frame内的第N行expr的值。如果没有这样的行，则返回值为NULL。


### NTILE(N)
将分区划分为N个组（bucket），为分区中的每一行分配其bucket(桶)编号，并返回其分区内当前行的bucket编号。

* 语法
    ```sql
    NTILE(N) over_clause
    ```