-- 索引使用示例讲解


-- 表结构
CREATE TABLE test03 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    c1 CHAR(10),
    c2 CHAR(10),
    c3 CHAR(10),
    c4 CHAR(10),
    c5 CHAR(10)
);

INSERT INTO test03 (c1, c2, c3, c4, c5) VALUES
('a1', 'a2', 'a3', 'a4', 'a5'),
('b1', 'b2', 'b3', 'b4', 'b5'),
('c1', 'c2', 'c3', 'c4', 'c5'),
('d1', 'd2', 'd3', 'd4', 'd5'),
('e1', 'e2', 'e3', 'e4', 'e5');

SELECT * FROM test03;

-- 创建索引
ALTER TABLE test03 ADD INDEX idx_test03_c1_c2_c3_c4 (c1, c2, c3, c4);
SHOW INDEX FROM test03;



-- 根据上面创建的索引idx_test03_c1_c2_c3_c4 (c1, c2, c3, c4), 分析以下SQL语句使用索引的情况
-- 1
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1';

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2';

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c3 = 'a3';

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c3 = 'a3' AND c4 = 'a4';


-- 
-- 2
EXPLAIN 
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2' AND c4 = 'a4' AND c3 = 'a3';

EXPLAIN 
SELECT * FROM test03
WHERE c4 = 'a4' AND c3 = 'a3' AND c2 = 'a2' AND c1 = 'a1';
/*
以上两个SQL语句，会被mysql的Optimizer优化器优化，把顺序调整为与索引字段顺序一致的查询语句
*/

-- 3
EXPLAIN 
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2' AND c3 > 'a3' AND c4 = 'a4';
/*
使用到了索引c1,c2,c3
*/

-- 4
EXPLAIN SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2' AND c4 > 'a4' AND c3 = 'a3';
/*
使用到了索引c1,c2,c3,c4，Optimizer优化器进行了SQL优化
*/

-- 5
EXPLAIN 
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2' AND c4 = 'a4'
ORDER BY c3;
/*
使用到了索引c1,c2,另外c3用于排序而非查找
*/

-- 6
EXPLAIN SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2'
ORDER BY c3;
/*
使用到了索引c1,c2,另外c3用于排序而非查找
*/

-- 7
EXPLAIN 
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2'
ORDER BY c4;
/*
type为ref,使用到了索引c1,c2，
Extra为Using filesort
*/


-- 8_1
EXPLAIN SELECT * FROM test03
WHERE c1 = 'a1' AND c5 = 'a5'
ORDER BY c2, c3;
/*
用到了索引c1，另外c2, c3使用索引排序，
type为ref，ref为const，Extra为Using where
*/

-- 8_2
EXPLAIN 
SELECT * FROM test03
WHERE c1 = 'a1' AND c5 = 'a5'
ORDER BY c3, c2;
/*
使用到了索引c1，另外c3, c2排序没有用到索引，因为索引列的顺序为c1,c2,c3,c4，而ORDER BY c2, c3没有按照索引列顺序，所以排序时索引失效了
type为ref，ref为const，Extra为Using where; Using filesort，做了一次临时排序(filesort)
*/


-- 9_1
EXPLAIN SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2'
ORDER BY c2, c3;

-- 9_2
EXPLAIN
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2' AND c5 = 'c5'
ORDER BY c2, c3;
/*
都用到了c1,c2索引，c2, c3用于排序，没有出现Using filesort
*/

-- 10
-- 10_1
EXPLAIN
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 = 'a2' AND c5 = 'c5'
ORDER BY c3, c2;
/*
用到了索引c1,c2，
type为ref，ref为const,const，Extra为Using where

这里为什么没有出现Using filesort呢？
这里主要是因为 c2 = 'a2'是一个const常量，既然只有一个常量，那么c2就无需排序了
ORDER BY c3, c2最终优化为ORDER BY c3

如果c2不是常量，如下面的示例
*/

-- 10_2
EXPLAIN
SELECT * FROM test03
WHERE c1 = 'a1' AND c2 > 'a2' AND c5 = 'c5'
ORDER BY c3, c2;
/*
用了索引c1,c2
type为range，Extra为Using index condition; Using where; Using filesort
这种情况下生产了Using filesort
*/
-- 与8_2的对比


-- 11_1
EXPLAIN
SELECT COUNT(*) FROM test03
WHERE c1 = 'a1' AND c4 = 'a4'
GROUP BY c2, c3;
/*
用到了索引c1，
type为ref，Extra为Using where; Using index
*/

-- 11_2
EXPLAIN
SELECT COUNT(*) FROM test03
WHERE c1 = 'a1' AND c4 = 'a4'
GROUP BY c3, c2;
/*
mysql 8
用到了索引c1，
type为ref，Extra为Using where; Using index; Using temporary
产生了Using temporary临时表

mysql 5.7
用到了索引c1，
type为ref，Extra为Using where; Using index; Using temporary; Using filesort
产生了Using temporary临时表、Using filesort排序
*/


