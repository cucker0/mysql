-- mysql高级_05_锁机制


-- 表锁
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



-- 行锁
-- 


-- 表结构
CREATE TABLE test_innodb_lock (
    a INT,
    b VARCHAR(16)
) ENGINE = INNODB;


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



