# window function窗口函数


-- 准备数据
CREATE DATABASE window_func;

USE window_func;

-- 容器操作演示1
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

-- 查看数据
SELECT * FROM sales ORDER BY country, YEAR, product;
/*
  year  country  product     profit  
------  -------  ----------  --------
  2000  Finland  Computer        1500
  2000  Finland  Phone            100
  2001  Finland  Phone             10
  2000  India    Calculator        75
  2000  India    Calculator        75
  2000  India    Computer        1200
  2000  USA      Calculator        75
  2000  USA      Computer        1500
  2001  USA      Calculator        50
  2001  USA      Computer        1500
  2001  USA      Computer        1200
  2001  USA      TV               150
  2001  USA      TV               100
*/

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

-- 需求：计算这个网站在每个城市的销售总额，在全国的销售总额、每个区域的销售总额中分别所占的比率。

## 方法1，（一般的方法）
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

## 方法2，使用窗口操作
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

-- 或
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


# 测试窗口函数
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

SELECT * FROM goods;
/*
    id  category_id  category             name               price   stock  shelf_time           
------  -----------  -------------------  ---------------  -------  ------  ---------------------
     1            1  女装/女士精品        T恤                39.90    1000    2021-12-20 00:00:00  
     2            1  女装/女士精品        连衣裙             79.90    2500    2021-12-20 00:00:00  
     3            1  女装/女士精品        卫衣               89.90    1500    2021-12-20 00:00:00  
     4            1  女装/女士精品        牛仔裤             89.90    3500    2021-12-20 00:00:00  
     5            1  女装/女士精品        百褶裙             29.90     500    2021-12-20 00:00:00  
     6            1  女装/女士精品        呢绒外套          399.90    1200    2021-12-20 00:00:00  
     7            2  户外运动             自行车            399.90    1000    2021-12-20 00:00:00  
     8            2  户外运动             山地自行车       1399.90    2500    2021-12-20 00:00:00  
     9            2  户外运动             登山杖             59.90    1300    2021-12-20 00:00:00  
    10            2  户外运动             骑行装备          399.90    3500    2021-12-20 00:00:00  
    11            2  户外运动             运动外套          799.90     500    2021-12-20 00:00:00  
    12            2  户外运动             滑板              499.90    1200    2021-12-20 00:00:00  
*/

## 1 序号函数
-- 1.1 ROW_NUMBER()
-- 示例：查询good表中的每个商品分类下按价格降序排列的每个商品信息。
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

-- 示例：查询goods表中每个商品分类下，价格价格最高的前3中商品的信息
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


-- 1.2 RANK()
-- 示例：对goods表中的每类商品按价格从高到底排名后的商品信息。
-- 即各类商品中第一个贵，第二贵...的是什么商品。

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


-- 示例：获取goods表中类别为 '女装/女士精品' 的价格最高的4款产品信息，并显示价格的排名
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

-- 1.3 DENSE_RANK()
-- 示例：获取goods表中各类别的价格从高到低排名的商品信息。相同价格则排名相同。
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


## 2 分布函数
-- 2.1 PERCENT_RANK()

-- 示例：计算goods表中'女装/女士精品'类别下商品的PERCENT_RANK值。

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


-- 2.2 CUME_DIST()
-- 示例：查询goods表中<=当前商品价格的比例
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

## 3 前后函数
-- 3.1 LAG(expr [, N[, default]]) [null_treatment] over_clause

-- 示例：查询goods表中各类别按价格升序排序后的每行商品的当前商品价格 减去 前一个商品价格 的差值。
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


-- 示例：查询goods表中各类别按价格升序排序后的每行商品的当前商品价格 减去 后一个商品价格 的差值。
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

## 4 收尾函数
-- 4.1 FIRST_VALUE()

-- 示例：goods表内商品分类别按价格升序排列，分类下的每个商品添加最低价字段。
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

-- 4.2 LAST_VALUE()
-- 示例：goods表内商品分类别按价格升序排列，分类下的每个商品添加当前类别的最高价格字段。
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

## 5 其他函数
-- 5.1 NTH_VALUE()
-- 示例：查询goods表中个类别价格排名第2、第4高的商品信息
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

-- 5.2 NTILE()
-- 示例：将goods表中的分类别后的商品价格降序降序后，再分成3组。
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
