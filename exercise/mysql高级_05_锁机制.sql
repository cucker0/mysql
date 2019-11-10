-- mysql高级_05_锁机制


-- MyISAM表锁
-- 

-- 表结构
CREATE TABLE mylock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20)
) ENGINE MYISAM;

INSERT INTO mylock (`name`) VALUES
('a'),
('b'),
('c'),
('d'),
('e'),
('f');

SHOW CREATE TABLE mylock;

SELECT * FROM mylock;


-- 查看表上加过的锁
SHOW OPEN TABLES WHERE `database` = 'testdb';

/*
In_use：
    0:没有锁，1:有锁
*/

SELECT * FROM staffs;



SHOW STATUS LIKE 'table%';



-- InnoDB行锁
-- 


-- 表结构
CREATE TABLE test_innodb_lock (
    a INT,
    b VARCHAR(16)
) ENGINE = INNODB;

TRUNCATE TABLE test_innodb_lock;
INSERT INTO test_innodb_lock VALUES
(1, 'b2'),
(3, '3'),
(4, '4000'),
(5, '5000'),
(6, '6000'),
(7, '7000'),
(8, '8000'),
(9, '9000'),
(1, 'b1');

SELECT * FROM test_innodb_lock;

-- 创建索引
CREATE INDEX idx_test_innodb_lock__a ON test_innodb_lock (a);

CREATE INDEX idx_test_innodb_lock__b ON test_innodb_lock (b);


-- 测试1

SHOW CREATE TABLE test_innodb_lock;
SELECT @@transaction_isolation;

SHOW INDEX FROM test_innodb_lock;

-- 表没有建任何的索引时，只使用表锁


-- innodb表手动锁定一行
SET autocommit = 0;

BEGIN;
SELECT 索引列 FROM 表名 WHERE 索引列 = 值 FOR UPDATE;
... ... -- 需要进行的操作
COMMIT;

SET autocommit = 1;

/*
注意：FOR关键字之前的查询能用上索引，才会写锁这行，
如果未用上索引，而是ALL全表扫描，则会锁定整个表

锁定前可以分析索引使用情况: explain SELECT 索引列 FROM 表名 WHERE 索引列 = 值; 
再执行行锁定操作
*/



-- 测试2
CREATE TABLE test_innodb_lock2 (
    a INT,
    b VARCHAR(16),
    note VARCHAR(64)
) ENGINE = INNODB;

TRUNCATE TABLE test_innodb_lock2;
INSERT INTO test_innodb_lock2 VALUES
(1, 'b1', 'n1'),
(3, 'b3', 'n3'),
(4, 'b4', 'n4'),
(5, 'b5', 'n5'),
(6, 'b6', 'n6'),
(7, 'b7', 'n7'),
(8, 'b8', 'n8');


-- 创建索引
CREATE INDEX idx_test_innodb_lock2__a ON test_innodb_lock2 (a);
CREATE INDEX idx_test_innodb_lock2__b ON test_innodb_lock2 (b);

SHOW INDEX FROM test_innodb_lock2;

SELECT * FROM test_innodb_lock2;




