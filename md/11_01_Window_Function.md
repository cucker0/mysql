Window Function窗口函数
==

窗口函数是mysql 8.0的新特性。

参考 https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html

https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html

## 窗口函数是什么
窗口函数对查询结果集做类似聚合函数的操作，  
但聚合函数将结果集的多行数据处理后只返回一个值（只有一行），  
而窗口函数则把处理后得出的结果作为一个字段 加到前面处理的查询结果集的每一行上

### 聚合函数做窗口操作
聚合函数是否当作窗口操作取决于是否有OVER ()子句。若有，则为窗口操作。

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

### 窗口操作演示2
准备数据
```mysql
-- 容器操作演示2
CREATE TABLE sales2 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(16),
    country VARCHAR(16),
    sales_volume DECIMAL
);

INSERT INTO sales2 (city, country, sales_volume) VALUES
('北京', '海淀', 10.00),
('北京', '朝阳', 20.00),
('上海', '黄埔', 30.00),
('上海', '长宁', 10.00);
```

* 需求：计算这个网站在每个城市的销售总额，在全国的销售总额、每个区域的销售总额中分别所占的比率。

* 方法1，（一般的方法）
    ```mysql
    -- 1. 创建临时表a，用于保存全国的销售总额
    CREATE TEMPORARY TABLE a 
    SELECT SUM(sales_volume) AS total_volume
    FROM sales2;
    
    SELECT * FROM a;
    /*
    total_volume  
    --------------
                70
    */
    
    -- 2. 创建临时表b，用于保存各区域的销售总额
    CREATE TEMPORARY TABLE b 
    SELECT city, SUM(sales_volume) AS city_total_vol
    FROM sales2
    GROUP BY city;
    
    SELECT * FROM b;
    /*
    city    city_total_vol  
    ------  ----------------
    北京                  30
    上海                  40
    */
    
    -- 3. 计算区域销售额比率、全国销售额比率
    SELECT 
        s.city AS 城市, 
        s.country AS 区域,
        sales_volume AS 区销售额,
        b.city_total_vol AS 市销售总额,
        a.total_volume 全国销售总额,
        CONCAT(ROUND((s.sales_volume / b.city_total_vol) * 100, 2), '%') AS 市比率,
        CONCAT(ROUND((s.sales_volume / a.total_volume) * 100, 2), '%') AS 全国比率    
    FROM sales2 AS s
    INNER JOIN b ON s.city=b.city
    CROSS JOIN a
    ORDER BY s.city, s.country;
    /*
    城市    区域    区销售额      市销售总额       全国销售总额        市比率     全国比率  
    ------  ------  ------------  ---------------  ------------------  ---------  --------------
    上海    长宁              10               40                  70  25.00%     14.29%        
    上海    黄埔              30               40                  70  75.00%     42.86%        
    北京    朝阳              20               30                  70  66.67%     28.57%        
    北京    海淀              10               30                  70  33.33%     14.29%        
    */
    ```

* 方法2，使用窗口操作
    ```mysql
    SELECT
        city 城市,
        country 区域,
        sales_volume 区销售额,
        zone_total_volume 市销售总额,
        total_volume 全国销售总额,
        CONCAT(ROUND((sales_volume / zone_total_volume) * 100, 2), '%') AS 市比率,
        CONCAT(ROUND((sales_volume / total_volume) * 100, 2), '%') AS 全国比率
    FROM (
        SELECT 
            city,
            country,
            sales_volume,
            SUM(sales_volume) OVER (PARTITION BY city) AS zone_total_volume,
            SUM(sales_volume) OVER () AS total_volume
        FROM sales2
        ORDER BY city, country
    ) AS t
    ;
    /*
    城市    区域    区销售额      市销售总额       全国销售总额        市比率     全国比率  
    ------  ------  ------------  ---------------  ------------------  ---------  --------------
    上海    长宁              10               40                  70  25.00%     14.29%        
    上海    黄埔              30               40                  70  75.00%     42.86%        
    北京    朝阳              20               30                  70  66.67%     28.57%        
    北京    海淀              10               30                  70  33.33%     14.29%          
    */
    ```
    
* 方法2，使用窗口操作
    ```mysql
    SELECT 
        city 城市,
        country 区域,
        sales_volume 区销售额,
        SUM(sales_volume) OVER w AS 市销售总额,
        SUM(sales_volume) OVER () AS 全国销售总额,
        (sales_volume / (SUM(sales_volume) OVER w)) AS 市比率,
        (sales_volume / (SUM(sales_volume) OVER ())) AS 全国比率
    FROM sales2
    WINDOW w AS (PARTITION BY city)
    ORDER BY city, country                          
    ;
    /*
    城市    区域    区销售额      市销售总额       全国销售总额        市比率     全国比率  
    ------  ------  ------------  ---------------  ------------------  ---------  --------------
    上海    长宁              10               40                  70     0.2500          0.1429
    上海    黄埔              30               40                  70     0.7500          0.4286
    北京    朝阳              20               30                  70     0.6667          0.2857
    北京    海淀              10               30                  70     0.3333          0.1429
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
    function(expr) over_clause AS alias_name
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

    参考 https://dev.mysql.com/doc/refman/8.0/en/window-functions-named-windows.html
    ```sql
    WINDOW window_name AS (window_spec)
        [, window_name AS (window_spec)] ...
    ```
    * 没有where子句，则window子句位于from ... table_name 后。
    * 有where子句，则window子句位紧跟where子句。
    * window子名位于HAVING子句和orderby子句之间
    * windows变量可以被OVER引用。  
    [示例见PERCENT_RANK()](#PERCENT_RANK)

**准备测试数据**
```mysql
-- 准备数据
CREATE TABLE goods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    category VARCHAR(16),
    `name` VARCHAR(32),
    price DECIMAL(10, 2),
    stock INT,
    shelf_time DATETIME
);

INSERT INTO goods (category_id, category, `name`, price, stock, shelf_time) VALUES
(1, '女装/女士精品', 'T恤', 39.90, 1000, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '连衣裙', 79.90, 2500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '卫衣', 89.90, 1500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '牛仔裤', 89.90, 3500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '百褶裙', 29.90, 500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '呢绒外套', 399.90, 1200, '2021-12-20 00:00:00'),
(2, '户外运动', '自行车', 399.90, 1000, '2021-12-20 00:00:00'),
(2, '户外运动', '山地自行车', 1399.90, 2500, '2021-12-20 00:00:00'),
(2, '户外运动', '登山杖', 59.90, 1300, '2021-12-20 00:00:00'),
(2, '户外运动', '骑行装备', 399.90, 3500, '2021-12-20 00:00:00'),
(2, '户外运动', '运动外套', 799.90, 500, '2021-12-20 00:00:00'),
(2, '户外运动', '滑板', 499.90, 1200, '2021-12-20 00:00:00')
;
```

### ROW_NUMBER()
返回当前行在其分区内的行编号。行编号的范围从1到分区行数。

ORDER BY字段相同的行，也会分配不同的行号。

ORDER BY影响行的编号顺序。没有ORDER BY，行编号是不确定的（实测为按默认的主键排序）。

* 语法
    ```sql
    ROW_NUMBER() over_clause
    ```

* 示例：查询good表中的每个商品分类下按价格降序排列的每个商品信息。
    ```mysql
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num,
        id, category_id, category, `name`, price, stock
    FROM goods;
    /*
    row_num      id  category_id  category             name               price   stock  
    -------  ------  -----------  -------------------  ---------------  -------  --------
          1       6            1  女装/女士精品        呢绒外套          399.90      1200
          2       3            1  女装/女士精品        卫衣               89.90      1500
          3       4            1  女装/女士精品        牛仔裤             89.90      3500
          4       2            1  女装/女士精品        连衣裙             79.90      2500
          5       1            1  女装/女士精品        T恤                39.90      1000
          6       5            1  女装/女士精品        百褶裙             29.90       500
          1       8            2  户外运动             山地自行车       1399.90      2500
          2      11            2  户外运动             运动外套          799.90       500
          3      12            2  户外运动             滑板              499.90      1200
          4       7            2  户外运动             自行车            399.90      1000
          5      10            2  户外运动             骑行装备          399.90      3500
          6       9            2  户外运动             登山杖             59.90      1300
    */
    ```

* 示例：查询goods表中每个商品分类下，价格价格最高的前3种商品的信息
    ```mysql
    SELECT * FROM (
        SELECT 
            ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num,
            id, category_id, category, `name`, price, stock
        FROM goods
    ) AS t
    WHERE row_num <= 3;
    /*
    row_num      id  category_id  category             name               price   stock  
    -------  ------  -----------  -------------------  ---------------  -------  --------
          1       6            1  女装/女士精品        呢绒外套          399.90      1200
          2       3            1  女装/女士精品        卫衣               89.90      1500
          3       4            1  女装/女士精品        牛仔裤             89.90      3500
          1       8            2  户外运动             山地自行车       1399.90      2500
          2      11            2  户外运动             运动外套          799.90       500
          3      12            2  户外运动             滑板              499.90      1200
    */
    ```
	
### RANK()
根据ORDER BY 字段，返回当前行在其分区内的排名，有间隙。值相同的的并列排名，会跳过重复的序号，如1,1,3

* 语法
    ```sql
    RANK() over_clause
    ```

* 示例：对goods表中的每类商品按价格从高到底排名后的商品信息。  
    即各类商品中第一个贵，第二贵...的是什么商品。
    ```mysql
    SELECT 
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS ranking,
        id, category_id, category, `name`, price, stock
    FROM goods;
    /*
    ranking      id  category_id  category             name               price   stock  
    -------  ------  -----------  -------------------  ---------------  -------  --------
          1       6            1  女装/女士精品        呢绒外套          399.90      1200
          2       3            1  女装/女士精品        卫衣               89.90      1500
          2       4            1  女装/女士精品        牛仔裤             89.90      3500
          4       2            1  女装/女士精品        连衣裙             79.90      2500
          5       1            1  女装/女士精品        T恤                39.90      1000
          6       5            1  女装/女士精品        百褶裙             29.90       500
          1       8            2  户外运动             山地自行车       1399.90      2500
          2      11            2  户外运动             运动外套          799.90       500
          3      12            2  户外运动             滑板              499.90      1200
          4       7            2  户外运动             自行车            399.90      1000
          4      10            2  户外运动             骑行装备          399.90      3500
          6       9            2  户外运动             登山杖             59.90      1300
    */
    ```

* 示例：获取goods表中类别为 '女装/女士精品' 的价格最高的4款产品信息，并显示价格的排名
    ```mysql
    SELECT * FROM (
        SELECT 
            RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS ranking,
            id, category_id, category, `name`, price, stock
        FROM goods
    ) AS t
    WHERE category='女装/女士精品' AND ranking <= 4;
    /*
    ranking      id  category_id  category             name           price   stock  
    -------  ------  -----------  -------------------  ------------  ------  --------
          1       6            1  女装/女士精品        呢绒外套      399.90      1200
          2       3            1  女装/女士精品        卫衣           89.90      1500
          2       4            1  女装/女士精品        牛仔裤         89.90      3500
          4       2            1  女装/女士精品        连衣裙         79.90      2500
    */
    ```

### DENSE_RANK()
返回当前行在其分区内的排名，不带间隙。order by字段相等的行视为同等级别（并列排名），不会跳过重复的序号，如1,1,2。

* 语法
    ```sql
    DENSE_RANK() over_clause
    ```

* 示例：获取goods表中各类别的价格从高到低排名的商品信息。相同价格则排名相同。
    ```mysql
    SELECT 
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS ranking,
        id, category_id, category, `name`, price, stock
    FROM goods;
    /*
    ranking      id  category_id  category             name               price   stock  
    -------  ------  -----------  -------------------  ---------------  -------  --------
          1       6            1  女装/女士精品        呢绒外套          399.90      1200
          2       3            1  女装/女士精品        卫衣               89.90      1500
          2       4            1  女装/女士精品        牛仔裤             89.90      3500
          3       2            1  女装/女士精品        连衣裙             79.90      2500
          4       1            1  女装/女士精品        T恤                39.90      1000
          5       5            1  女装/女士精品        百褶裙             29.90       500
          1       8            2  户外运动             山地自行车       1399.90      2500
          2      11            2  户外运动             运动外套          799.90       500
          3      12            2  户外运动             滑板              499.90      1200
          4       7            2  户外运动             自行车            399.90      1000
          4      10            2  户外运动             骑行装备          399.90      3500
          5       9            2  户外运动             登山杖             59.90      1300
    */
    ```


### PERCENT_RANK()
返回小于当前行中的值（不包括最高值）的分区值百分比。返回值的范围：[0, 1]，表示行的相对排名

* 计算公式
    ```sql
    (rank - 1) / (rows - 1)
    ```
    rank  行的排名，RANK()函数产生的排名。
    rows  该分区内的总行数

* 示例：计算goods表中'女装/女士精品'类别下商品的PERCENT_RANK值。
    ```mysql
    -- 写法1
    SELECT 
        RANK() OVER (PARTITION BY category_id ORDER BY price ASC) AS ranking,
        PERCENT_RANK() OVER (PARTITION BY category_id ORDER BY price ASC) AS percent_ranking,
        id, category_id, category, `name`, price, stock
    FROM goods
    WHERE category='女装/女士精品'
    ;
    
    -- 写法2
    SELECT 
        RANK() OVER w AS ranking,
        PERCENT_RANK() OVER w AS percent_ranking,
        id, category_id, category, `name`, price, stock
    FROM goods
    WHERE category='女装/女士精品'
    WINDOW w AS (PARTITION BY category_id ORDER BY price ASC)
    ;
    
    /*
    ranking  percent_ranking      id  category_id  category             name           price   stock  
    -------  ---------------  ------  -----------  -------------------  ------------  ------  --------
          1                0       5            1  女装/女士精品        百褶裙         29.90       500
          2              0.2       1            1  女装/女士精品        T恤            39.90      1000
          3              0.4       2            1  女装/女士精品        连衣裙         79.90      2500
          4              0.6       3            1  女装/女士精品        卫衣           89.90      1500
          4              0.6       4            1  女装/女士精品        牛仔裤         89.90      3500
          6                1       6            1  女装/女士精品        呢绒外套      399.90      1200
    */
    ```

### CUME_DIST()
返回一组值内的累计分布值。即分区值小于或等于当前行中的值的百分比。

* 语法
    ```sql
    PERCENT_RANK() over_clause
    ```

* 示例：查询goods表中<=当前商品价格的比例
    ```mysql
    SELECT 
        CUME_DIST() OVER (PARTITION BY category_id ORDER BY price ASC) AS proportion,
        id, category_id, category, `name`, price, stock
    FROM goods;
    /*
             proportion      id  category_id  category             name               price   stock  
    -------------------  ------  -----------  -------------------  ---------------  -------  --------
    0.16666666666666666       5            1  女装/女士精品        百褶裙             29.90       500
     0.3333333333333333       1            1  女装/女士精品        T恤                39.90      1000
                    0.5       2            1  女装/女士精品        连衣裙             79.90      2500
     0.8333333333333334       3            1  女装/女士精品        卫衣               89.90      1500
     0.8333333333333334       4            1  女装/女士精品        牛仔裤             89.90      3500
                      1       6            1  女装/女士精品        呢绒外套          399.90      1200
    0.16666666666666666       9            2  户外运动             登山杖             59.90      1300
                    0.5       7            2  户外运动             自行车            399.90      1000
                    0.5      10            2  户外运动             骑行装备          399.90      3500
     0.6666666666666666      12            2  户外运动             滑板              499.90      1200
     0.8333333333333334      11            2  户外运动             运动外套          799.90       500
                      1       8            2  户外运动             山地自行车       1399.90      2500
    */
    ```

### LAG()
返回位于当前分区当前行的前N行的expr值。

* 语法
    ```sql
    LAG(expr [, N[, default]]) [null_treatment] over_clause
    ```
    * 返回位于当前分区当前行前N行的expr值。  
    * 如果不存在这样的行，则返回 default 值。  
    * N缺省值为1  
    * default缺省值为NULL
    * N为自然数（0, 1, 2 ...），范围：[1, 2<sup>63</sup>]，不能为负整数。N为0：则返回当前行的expr值
    * 从mysql  8.0.22开始，N不能为NULL值
    * null_treatment  NULL值的处理方式，  
        RESPECT NULLS（默认值，接受NULL值），  
        IGNORE NULLS（忽略NULL值，并产生一个错误）  
        其他地方的同此。
        
* 示例：查询goods表中各类别按价格升序排序后的每行商品的当前商品价格 减去 前一个商品价格 的差值。
    ```mysql
    SELECT 
        id, category, `name`, price, 
        price - previous_price AS diff_previous_price
    FROM (
        SELECT 
            LAG(price, 1) OVER w AS previous_price,
            id, category, `name`, price
        FROM goods
        WINDOW w AS (PARTITION BY category_id ORDER BY price)
    ) AS t;
    
    -- 等价于
    SELECT 
        id, category, `name`, price, 
        price - previous_price AS diff_previous_price
    FROM (
        SELECT 
            LAG(price, 1) OVER (PARTITION BY category_id ORDER BY price) AS previous_price,
            id, category, `name`, price
        FROM goods
    ) AS t;
    
    /*
        id  category             name               price  diff_previous_price  
    ------  -------------------  ---------------  -------  ---------------------
         5  女装/女士精品        百褶裙             29.90                 (NULL)
         1  女装/女士精品        T恤                39.90                  10.00
         2  女装/女士精品        连衣裙             79.90                  40.00
         3  女装/女士精品        卫衣               89.90                  10.00
         4  女装/女士精品        牛仔裤             89.90                   0.00
         6  女装/女士精品        呢绒外套          399.90                 310.00
         9  户外运动             登山杖             59.90                 (NULL)
         7  户外运动             自行车            399.90                 340.00
        10  户外运动             骑行装备          399.90                   0.00
        12  户外运动             滑板              499.90                 100.00
        11  户外运动             运动外套          799.90                 300.00
         8  户外运动             山地自行车       1399.90                 600.00
    */
    ```

### LEAD()
返回在分区内的当前行的后N行的expr值。

* 语法
    ```sql
    LEAD(expr [, N[, default]]) [null_treatment] over_clause
    ```
    * 返回在分区内的当前行的后N行的expr值。
    * 如果不存在这样的行，则返回 default 值。  
    * N缺省值为1  
    * default缺省值为NULL
    * N为自然数（0, 1, 2 ...），范围：[1, 2<sup>63</sup>]，不能为负整数。N为0：则返回当前行的expr值
    * 从mysql  8.0.22开始，N不能为NULL值
    
* 示例：查询goods表中各类别按价格升序排序后的每行商品的当前商品价格 减去 后一个商品价格 的差值。
    ```mysql
    SELECT 
        id, category, `name`, price, 
        price - previous_price AS diff_next_price
    FROM (
        SELECT 
            LEAD(price, 1) OVER w AS previous_price,
            id, category, `name`, price
        FROM goods
        WINDOW w AS (PARTITION BY category_id ORDER BY price)
    ) AS t;
    /*
        id  category             name               price  diff_next_price  
    ------  -------------------  ---------------  -------  -----------------
         5  女装/女士精品        百褶裙             29.90             -10.00
         1  女装/女士精品        T恤                39.90             -40.00
         2  女装/女士精品        连衣裙             79.90             -10.00
         3  女装/女士精品        卫衣               89.90               0.00
         4  女装/女士精品        牛仔裤             89.90            -310.00
         6  女装/女士精品        呢绒外套          399.90             (NULL)
         9  户外运动             登山杖             59.90            -340.00
         7  户外运动             自行车            399.90               0.00
        10  户外运动             骑行装备          399.90            -100.00
        12  户外运动             滑板              499.90            -300.00
        11  户外运动             运动外套          799.90            -600.00
         8  户外运动             山地自行车       1399.90             (NULL)
    */
    ```

### FIRST_VALUE(expr)
Returns the value of expr from the first row of the window frame.
返回当前window frame中的的第一行中的expr值。即分区内的第一行的expr值。

* 语法
    ```sql
    FIRST_VALUE(expr) [null_treatment] over_clause
    ```
* 示例：goods表内商品分类别按价格升序排列，分类下的每个商品添加最低价字段。
    ```mysql
    SELECT 
        id, category, `name`, price,  
        FIRST_VALUE(price) OVER w AS first_price
    FROM goods
    WINDOW w AS (PARTITION BY category_id ORDER BY price ASC)
    ;
    /*
        id  category             name               price  first_price  
    ------  -------------------  ---------------  -------  -------------
         5  女装/女士精品        百褶裙             29.90          29.90
         1  女装/女士精品        T恤                39.90          29.90
         2  女装/女士精品        连衣裙             79.90          29.90
         3  女装/女士精品        卫衣               89.90          29.90
         4  女装/女士精品        牛仔裤             89.90          29.90
         6  女装/女士精品        呢绒外套          399.90          29.90
         9  户外运动             登山杖             59.90          59.90
         7  户外运动             自行车            399.90          59.90
        10  户外运动             骑行装备          399.90          59.90
        12  户外运动             滑板              499.90          59.90
        11  户外运动             运动外套          799.90          59.90
         8  户外运动             山地自行车       1399.90          59.90
    */
    ```

### LAST_VALUE(expr)
Returns the value of expr from the last row of the window frame.
返回当前window frame中的最后一行的expr值。frame子句缺省的情况下，就是当前行的 expr，不是分区内的最后一行。

要取分区内的最后一行，可添加frame子句
```sql
ORDER BY expr 
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

* 语法
    ```sql
    LAST_VALUE(expr) [null_treatment] over_clause
    ```

* 示例：goods表内商品分类别按价格升序排列，分类下的每个商品添加当前类别的最高价格字段。
    ```mysql
    SELECT 
        id, category, `name`, price,  
        LAST_VALUE(price) OVER w AS last_price
    FROM goods
    WINDOW w AS (PARTITION BY category_id ORDER BY price ASC)
    ;
    /*
        id  category             name               price  last_price  
    ------  -------------------  ---------------  -------  ------------
         5  女装/女士精品        百褶裙             29.90         29.90
         1  女装/女士精品        T恤                39.90         39.90
         2  女装/女士精品        连衣裙             79.90         79.90
         3  女装/女士精品        卫衣               89.90         89.90
         4  女装/女士精品        牛仔裤             89.90         89.90
         6  女装/女士精品        呢绒外套          399.90        399.90
         9  户外运动             登山杖             59.90         59.90
         7  户外运动             自行车            399.90        399.90
        10  户外运动             骑行装备          399.90        399.90
        12  户外运动             滑板              499.90        499.90
        11  户外运动             运动外套          799.90        799.90
         8  户外运动             山地自行车       1399.90       1399.90
    */
    -- **为什么 last_price 是当前行的价格呢?**
    -- 这时因为frame_clause子句缺省的情况下为：`ROWS CURRENT ROW`，即window frame从第一行 到 当前行。
    
    -- 分区内的最后一行的表示方法
    SELECT 
        id, category, `name`, price,
        LAST_VALUE(price) OVER w AS last_price
    FROM goods
    WINDOW w AS (
        PARTITION BY category_id ORDER BY price ASC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
    ;
    /*
        id  category             name               price  last_price  
    ------  -------------------  ---------------  -------  ------------
         5  女装/女士精品        百褶裙             29.90        399.90
         1  女装/女士精品        T恤                39.90        399.90
         2  女装/女士精品        连衣裙             79.90        399.90
         3  女装/女士精品        卫衣               89.90        399.90
         4  女装/女士精品        牛仔裤             89.90        399.90
         6  女装/女士精品        呢绒外套          399.90        399.90
         9  户外运动             登山杖             59.90       1399.90
         7  户外运动             自行车            399.90       1399.90
        10  户外运动             骑行装备          399.90       1399.90
        12  户外运动             滑板              499.90       1399.90
        11  户外运动             运动外套          799.90       1399.90
         8  户外运动             山地自行车       1399.90       1399.90
    */
    ```

### NTH_VALUE(expr, N)
返回windows frame内的第N行expr的值。如果没有这样的行，则返回值为NULL。

* 语法
    ```sql
    NTH_VALUE(expr, N) [from_first_last] [null_treatment] over_clause
    ```

* 示例：查询goods表中个类别价格排名第2、第4高的商品信息
    ```mysql
    SELECT 
        id, category, `name`, price,
        NTH_VALUE(price, 2) OVER w AS second_price,
        NTH_VALUE(price, 4) OVER w AS fourth_price
    FROM goods
    WINDOW w AS (
        PARTITION BY category_id ORDER BY price ASC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    );
    /*
        id  category             name               price  second_price  fourth_price  
    ------  -------------------  ---------------  -------  ------------  --------------
         5  女装/女士精品        百褶裙             29.90         39.90           89.90
         1  女装/女士精品        T恤                39.90         39.90           89.90
         2  女装/女士精品        连衣裙             79.90         39.90           89.90
         3  女装/女士精品        卫衣               89.90         39.90           89.90
         4  女装/女士精品        牛仔裤             89.90         39.90           89.90
         6  女装/女士精品        呢绒外套          399.90         39.90           89.90
         9  户外运动             登山杖             59.90        399.90          499.90
         7  户外运动             自行车            399.90        399.90          499.90
        10  户外运动             骑行装备          399.90        399.90          499.90
        12  户外运动             滑板              499.90        399.90          499.90
        11  户外运动             运动外套          799.90        399.90          499.90
         8  户外运动             山地自行车       1399.90        399.90          499.90
    */
    
    SELECT 
        id, category, `name`, price,
        NTH_VALUE(price, 2) OVER w AS second_price,
        NTH_VALUE(price, 4) OVER w AS fourth_price
    FROM goods
    WINDOW w AS (
        PARTITION BY category_id ORDER BY price ASC
    );
    /*
        id  category             name               price  second_price  fourth_price  
    ------  -------------------  ---------------  -------  ------------  --------------
         5  女装/女士精品        百褶裙             29.90        (NULL)          (NULL)
         1  女装/女士精品        T恤                39.90         39.90          (NULL)
         2  女装/女士精品        连衣裙             79.90         39.90          (NULL)
         3  女装/女士精品        卫衣               89.90         39.90           89.90
         4  女装/女士精品        牛仔裤             89.90         39.90           89.90
         6  女装/女士精品        呢绒外套          399.90         39.90           89.90
         9  户外运动             登山杖             59.90        (NULL)          (NULL)
         7  户外运动             自行车            399.90        399.90          (NULL)
        10  户外运动             骑行装备          399.90        399.90          (NULL)
        12  户外运动             滑板              499.90        399.90          499.90
        11  户外运动             运动外套          799.90        399.90          499.90
         8  户外运动             山地自行车       1399.90        399.90          499.90
    */
    -- second_price、fourth_price出现'(NULL)'的原因同 LAST_VALUE()的缺省frame子句的原因
    ```

### NTILE(N)
将分区划分为N个组（bucket），为分区中的每一行分配其bucket(桶)编号，并返回其分区内当前行的bucket编号。

* 语法
    ```sql
    NTILE(N) over_clause
    ```
* 示例：将goods表中的分类别后的商品价格降序降序后，再分成3组。
    ```mysql
    SELECT 
        NTILE(3) OVER w AS bucket_num,
        id, category, `name`, price, stock
    FROM goods
    WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);
    /*
    bucket_num      id  category             name               price   stock  
    ----------  ------  -------------------  ---------------  -------  --------
             1       6  女装/女士精品        呢绒外套          399.90      1200
             1       3  女装/女士精品        卫衣               89.90      1500
             2       4  女装/女士精品        牛仔裤             89.90      3500
             2       2  女装/女士精品        连衣裙             79.90      2500
             3       1  女装/女士精品        T恤                39.90      1000
             3       5  女装/女士精品        百褶裙             29.90       500
             1       8  户外运动             山地自行车       1399.90      2500
             1      11  户外运动             运动外套          799.90       500
             2      12  户外运动             滑板              499.90      1200
             2       7  户外运动             自行车            399.90      1000
             3      10  户外运动             骑行装备          399.90      3500
             3       9  户外运动             登山杖             59.90      1300
    */
    
    
    SELECT 
        NTILE(4) OVER w AS bucket_num,
        id, category, `name`, price, stock
    FROM goods
    WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);
    /*
    bucket_num      id  category             name               price   stock  
    ----------  ------  -------------------  ---------------  -------  --------
             1       6  女装/女士精品        呢绒外套          399.90      1200
             1       3  女装/女士精品        卫衣               89.90      1500
             2       4  女装/女士精品        牛仔裤             89.90      3500
             2       2  女装/女士精品        连衣裙             79.90      2500
             3       1  女装/女士精品        T恤                39.90      1000
             4       5  女装/女士精品        百褶裙             29.90       500
             1       8  户外运动             山地自行车       1399.90      2500
             1      11  户外运动             运动外套          799.90       500
             2      12  户外运动             滑板              499.90      1200
             2       7  户外运动             自行车            399.90      1000
             3      10  户外运动             骑行装备          399.90      3500
             4       9  户外运动             登山杖             59.90      1300
    */
    
    SELECT 
        NTILE(5) OVER w AS bucket_num,
        id, category, `name`, price, stock
    FROM goods
    WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);
    /*
    bucket_num      id  category             name               price   stock  
    ----------  ------  -------------------  ---------------  -------  --------
             1       6  女装/女士精品        呢绒外套          399.90      1200
             1       3  女装/女士精品        卫衣               89.90      1500
             2       4  女装/女士精品        牛仔裤             89.90      3500
             3       2  女装/女士精品        连衣裙             79.90      2500
             4       1  女装/女士精品        T恤                39.90      1000
             5       5  女装/女士精品        百褶裙             29.90       500
             1       8  户外运动             山地自行车       1399.90      2500
             1      11  户外运动             运动外套          799.90       500
             2      12  户外运动             滑板              499.90      1200
             3       7  户外运动             自行车            399.90      1000
             4      10  户外运动             骑行装备          399.90      3500
             5       9  户外运动             登山杖             59.90      1300
    */
    
    SELECT 
        NTILE(10) OVER w AS bucket_num,
        id, category, `name`, price, stock
    FROM goods
    WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);
    /*
    bucket_num      id  category             name               price   stock  
    ----------  ------  -------------------  ---------------  -------  --------
             1       6  女装/女士精品        呢绒外套          399.90      1200
             2       3  女装/女士精品        卫衣               89.90      1500
             3       4  女装/女士精品        牛仔裤             89.90      3500
             4       2  女装/女士精品        连衣裙             79.90      2500
             5       1  女装/女士精品        T恤                39.90      1000
             6       5  女装/女士精品        百褶裙             29.90       500
             1       8  户外运动             山地自行车       1399.90      2500
             2      11  户外运动             运动外套          799.90       500
             3      12  户外运动             滑板              499.90      1200
             4       7  户外运动             自行车            399.90      1000
             5      10  户外运动             骑行装备          399.90      3500
             6       9  户外运动             登山杖             59.90      1300
    */
    ```