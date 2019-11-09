-- mysql高级_05_锁机制


-- 表
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
