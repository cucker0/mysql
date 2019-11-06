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
    birth TIMESTAMP NOT NULL
);


INSERT INTO taba (age, birth) VALUES
(22, NOW()),
(23, NOW()),
(24, NOW());

-- 建立索引
CREATE INDEX idx_taba_age_birth ON taba (age, birth);

SHOW INDEX FROM taba;

-- 1_0
EXPLAIN
SELECT * FROM taba
WHERE age = 20;

-- 1_1
EXPLAIN
SELECT * FROM taba 
WHERE age > 20
ORDER BY age;


-- 1_2
EXPLAIN
SELECT * FROM taba
WHERE age > 20
ORDER BY age, birth;

-- 1_3
EXPLAIN
SELECT * FROM taba
WHERE age > 20
ORDER BY birth;

-- 1_4
EXPLAIN
SELECT * FROM taba
WHERE age > 20
ORDER BY birth, age;



-- 2_1
EXPLAIN
SELECT * FROM taba 
ORDER BY birth;

-- 2_2
EXPLAIN
SELECT * FROM taba
WHERE birth > '2019-11-06 00:00:00'
ORDER BY birth;

-- 2_3
EXPLAIN
SELECT * FROM taba
WHERE birth > '2019-11-06 00:00:00'
ORDER BY age;
-- 与1_3的比较

-- 2_4
EXPLAIN
SELECT * FROM taba
ORDER BY age ASC, birth DESC;




















