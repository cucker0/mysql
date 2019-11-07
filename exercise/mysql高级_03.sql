-- 查询截取分析



-- 优化原则：小表驱动大表，即少的数据集驱动多的数据集
-- 

-- 示例：A表、B表
CREATE TABLE A (
    id INT,
    cname VARCHAR(32)
);

CREATE TABLE B (
    id INT,
    score INT
);

ALTER TABLE A ADD INDEX idx_a_id (id);
ALTER TABLE B ADD INDEX idx_b_id (id);

-- 
SELECT * FROM A WHERE id IN (SELECT id FROM B)

-- 等价于：
FOR (SELECT id FROM B) {
    SELECT * FROM A WHERE A.id = B.id
}
    

/*
当B表的数据集小于A表的数据集时，用in优于exists
*/


SELECT * FROM A WHERE EXISTS (SELECT 1 FROM B WHERE B.id = A.id)

-- 等价于
FOR (SELECT * FROM A) {
    SELECT 1 FROM B WHERE B.id = A.id
}


/*
当A表的数据集小于B表的数据集时，用exists优于in

注意：
A表与B表的id字段应建立索引

EXISTS子句理解：
将主查询的数据，放到子查询中做条件验证，只保留验证结果为true的主数据
*/



-- order by优化
-- 
CREATE TABLE taba (
    age INT,
    birth TIMESTAMP NOT NULL,
    `comment` VARCHAR(255)
);


INSERT INTO taba (age, birth, `comment`) VALUES
(22, NOW(), '22岁'),
(23, NOW(), '23岁'),
(24, NOW(), '24岁');

SELECT * FROM taba;

-- 建立索引
CREATE INDEX idx_taba_age_birth ON taba (age, birth);

SHOW INDEX FROM taba;

-- 1_0
EXPLAIN
SELECT * FROM taba
WHERE age = 20;


/*
如何确定order by用了哪种方式排序，
可以先用explain 执行到where子句，
再explain 执行到order by子句
通过对比两次的分析结果，就可以看出order by使用的排序方式
*/
-- 1_1
EXPLAIN
SELECT age, birth FROM taba 
WHERE age > 20
ORDER BY age;
/*
order by排序方式：index
用到索引age,birth
type为index
Extra为Using where; Using index
*/

--
EXPLAIN
SELECT * FROM taba 
WHERE age > 20
ORDER BY age;
/*
order by排序方式：index
用到索引age
type为range
Extra为Using index condition
*/


-- 1_2
EXPLAIN
SELECT age, birth FROM taba
WHERE age > 20
ORDER BY age, birth;
/*
order by排序方式：index
用到索引age,birth
type为index
Extra为Using where; Using index
*/

-- 
EXPLAIN
SELECT * FROM taba
WHERE age > 20
ORDER BY age, birth;
/*
order by排序方式：index
用到索引age
type为range
Extra为Using index condition
*/

-- 1_3
EXPLAIN
SELECT age, birth FROM taba
WHERE age > 20
ORDER BY birth;
/*
order by排序方式：filesort
用到索引age,birth
type为index
Extra为Using where; Using index; Using filesort
*/

-- 
EXPLAIN
SELECT * FROM taba
WHERE age > 20
ORDER BY birth;
/*
order by排序方式：filesort
用到索引age
type为range
Extra为Using index condition; Using filesort
*/


-- 1_4
EXPLAIN
SELECT age, birth FROM taba
WHERE age > 20
ORDER BY birth, age;
/*
order by排序方式：filesort
用到索引age,birth
type为index
Extra为Using where; Using index; Using filesort
*/

--
EXPLAIN
SELECT * FROM taba
WHERE age > 20
ORDER BY birth, age;
/*
order by排序方式：filesort
用到索引age
type为range
Extra为Using index condition; Using filesort
*/

EXPLAIN
SELECT age, birth FROM taba
WHERE age = 20
ORDER BY birth, age;
/*
order by排序方式：index
用到索引age
type为ref
Extra为Using index
*/

-- 2_1
EXPLAIN
SELECT age, birth FROM taba 
ORDER BY birth;
/*
order by排序方式：filesort
用到索引age,birth
type为index
Extra为Using index; Using filesort
*/

-- 
EXPLAIN
SELECT * FROM taba 
ORDER BY birth;
/*
order by排序方式：filesort
没有用到索引
type为ALL，全表扫描
Extra为Using filesort
*/

-- 2_2
EXPLAIN
SELECT age, birth FROM taba
WHERE birth > '2019-11-06 00:00:00'
ORDER BY birth;
/*
order by排序方式：filesort
用到索引age,birth
type为index
Extra为Using where; Using index; Using filesort
*/

-- 
EXPLAIN
SELECT * FROM taba
WHERE birth > '2019-11-06 00:00:00'
ORDER BY birth;
/*
order by排序方式：filesort
没有用到索引
type为ALL，全表扫描
Extra为Using where; Using filesort
*/

-- 2_3
EXPLAIN
SELECT age, birth FROM taba
WHERE birth > '2019-11-06 00:00:00'
ORDER BY age;
/*
-- 与1_3的比较

order by排序方式：index
用到索引age,birth
type为index
Extra为Using where; Using index

这里为什么只用到了index排序，而没有产生filesort排序呢？
这主要是因为使用到了覆盖索引，因为idx_taba_age_birth (age, birth) 而select * 即为 select age, birth
*/
-- 
EXPLAIN
SELECT * FROM taba
WHERE birth > '2019-11-06 00:00:00'
ORDER BY age;
/*
order by排序方式：filesort
没有用到索引
type为ALL，全表扫描
Extra为Using where; Using filesort
*/

-- 2_4
EXPLAIN
SELECT age, birth FROM taba
ORDER BY age ASC, birth DESC;
/*
order by排序方式：filesort
用到索引age,birth
type为index
Extra为Using index; Using filesort
*/

-- 
EXPLAIN
SELECT * FROM taba
ORDER BY age ASC, birth DESC;
/*
order by排序方式：filesort
没有用到索引
type为ALL，全表扫描
Extra为Using filesort
*/

-- 2_5
EXPLAIN
SELECT age, birth FROM taba
ORDER BY age DESC, birth DESC;
/*
order by排序方式：index
用到索引age,birth
type为index
Extra为Backward index scan; Using index

为什么没有产生filesort
这是因为ORDER BY排序的字段的排序方向一致，
默认索引字段的排序是asc升序，所以这里出现了反向索引扫描(Backward index scan)
*/

--
EXPLAIN
SELECT * FROM taba
ORDER BY age DESC, birth DESC;
/*
order by排序方式：filesort
没有用到索引
type为ALL，全表扫描
Extra为Using filesort
*/

-- 2_6
EXPLAIN
SELECT age, birth FROM taba
WHERE age IN (20, 22) ORDER BY birth;
/*
order by排序方式：filesort
用到了索引age
type为range
Extra为Using where; Using index; Using filesort
*/


-- 为order by排序使用index
-- 
/*
mysql有两种排序方式：filesort、index


mysql能为排序和查询使用相同的索引

index a_b_c (a, b, c)
*/


-- order by符合最佳左前缀法，则能用到index排序，如下：
-- 注意 ...表示覆盖索引，下面的示例也相同
... ORDER BY a;
... ORDER BY a, b;
... ORDER BY a, b, c;
... ORDER BY a, DESC, b DESC, c DESC; -- 排序字段的排序方向都一致，所以能用到index排序


-- 如果where使用索引的最左前缀定义为常量，则order by能使用索引
... WHERE a = const ORDER BY b, c;
... WHERE a = const AND b = const ORDER BY c;
... WHERE a = const ORDER BY b, c;
... WHERE a = const AND b > const ORDER BY b, c;


-- 不能使用索引进行排序
... ORDER BY a ASC, b DESC, c DESC;  -- order by排序字段的排序方向不一致
... WHERE g = const ORDER BY b, c;  -- 丢失索引a字段
... WHERE a = const ORDER BY c;  -- 丢失索引b字段
... WHERE a = const ORDER BY a, d;  -- 字段d不是索引字段
... WHERE a IN (...) ORDER BY b, c;  -- 对于排序来说，多个相等条件也是范围











