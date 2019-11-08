-- mysql高级_04


SHOW GLOBAL VARIABLES LIKE 'log_output';

SHOW GLOBAL VARIABLES LIKE 'slow_query_log';

SHOW GLOBAL VARIABLES LIKE 'long_query_time';

SHOW GLOBAL VARIABLES LIKE 'slow_query_log_file';

SHOW GLOBAL VARIABLES LIKE 'log_queries_not_using_indexes';

SET GLOBAL slow_query_log = 1;

SET GLOBAL long_query_time = 3;


-- 
SELECT * FROM (SELECT SLEEP(5)) t;

SHOW SESSION VARIABLES LIKE 'long_query_time';

-- 查看当前系统中有多少条慢查询日志
SHOW GLOBAL STATUS LIKE '%Slow_queries%';



-- 向表中批量插入数据
-- 
CREATE TABLE dept (  -- 部门表
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    deptno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    dname VARCHAR(20) NOT NULL DEFAULT '',
    loc VARCHAR(13) NOT NULL DEFAULT ''  -- 楼层
);


CREATE TABLE emp (  -- 员工表
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    empno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,  -- 编号
    ename VARCHAR(20) NOT NULL DEFAULT '',  -- 部门名
    job VARCHAR(9) NOT NULL DEFAULT '',  -- 职位
    mgr MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,  -- 上级领导编号
    hirdate DATE NOT NULL,  -- 入职时间
    sal DECIMAL(7, 2) NOT NULL,  -- 薪水
    comm DECIMAL(7, 2) NOT NULL,  -- 分红
    deptno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0  -- 所在部门编号
);

DESC emp;
DESC dept;



-- 产生指定长度的随机字符串函数
DELIMITER $
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
/*产生指定长度的随机字符串函数
in
---
    n: 要生成的字符串长度
return:  指定长度的随机字符串
*/
BEGIN
    DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE return_str VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 0;
    
    WHILE i < n DO
        SET return_str = CONCAT(return_str, SUBSTR(chars_str, CEIL(RAND() * 52), 1));
        SET i = i + 1;
    END WHILE;
    
    RETURN return_str;
END$

DELIMITER ;



-- 产生随机部门编号函数
DELIMITER $
CREATE FUNCTION rand_num() RETURNS INT
/*产生随机部门编号函数

in
--

return: 部门编号
*/
BEGIN
    DECLARE i INT DEFAULT 0;
    SET i = CEIL(100 + RAND() * 10);  -- 让部门编号从100起
    RETURN i;
END $

DELIMITER ;


-- 创建往emp表中插入数据的存储过程
DELIMITER $
CREATE PROCEDURE insert_emp(IN s INT, IN len INT)
/*向emp表中插入数据

in
---
    s: 员工编号起始值
    len: 要添加的员工个数
out
---
   
*/
BEGIN
    DECLARE i INT DEFAULT 0;
    SET autocommit = 0;  -- 关闭事务自动提交
    
    WHILE i < len DO
        INSERT INTO emp (empno, ename, job, mgr, hirdate, sal, comm, deptno)
        VALUES ((s + i), rand_string(6), 'SALESMAN', 0001, CURDATE(), 2000, 400, rand_num());
        SET i = i + 1;
    END WHILE;
    
    COMMIT;  -- 提交事务
END$

DELIMITER ;


-- 创建往dept表中插入数据的存储过程
DELIMITER $
CREATE PROCEDURE insert_dept(IN s INT, IN len INT)
/*向dept表中插入数据

in
---
    s: 部门编号起始值
    len: 要添加的部门个数
out
---
   
*/
BEGIN
    DECLARE i INT DEFAULT 0;
    SET autocommit = 0;
    
    WHILE i < len DO
        INSERT INTO dept (deptno, dname, loc)
        VALUES ((s + i), rand_string(10), rand_string(8));
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END$

DELIMITER ;

-- 查看创建的函数
SELECT * FROM information_schema.routines
WHERE routine_schema = 'testdb' AND routine_type = 'FUNCTION';

-- 查看创建的存储过程
SELECT * FROM information_schema.routines
WHERE routine_schema = 'testdb' AND routine_type = 'PROCEDURE';

CALL insert_dept(100, 10);
SELECT * FROM dept;

CALL insert_emp(1001, 500000);

USE testdb;
SELECT * FROM emp LIMIT 0, 100;



-- show profiles、show profile
-- 

-- 查看profiling性能信息收集功能是否开启
SHOW VARIABLES LIKE 'profiling';

-- 查看profiling历史容量
SHOW VARIABLES LIKE 'profiling_history_size';

-- profiling历史容量
SET profiling_history_size = 100;

SHOW VARIABLES LIKE 'profil%';

-- 开启性能信息收集
SET profiling = 1;


SELECT * FROM dept;
SELECT ename, CONCAT('group_', id % 10) AS 组 FROM emp LIMIT 150000;
SELECT * FROM emp ORDER BY id % 10, LENGTH(ename) LIMIT 150000;
SELECT SLEEP(3);
SELECT * FROM book;
SELECT * FROM t1,
SELECT * FROM t2;

-- 
SHOW PROFILES;


SHOW PROFILE FOR QUERY 173;

SHOW PROFILE CPU, BLOCK IO FOR QUERY 189;





-- Performance Schema性能查看与分析
-- 

-- 默认setup_actors设置器对所有前台线程(所有会话)进行监听、收集历史sql语句
SELECT * FROM performance_schema.setup_actors;


-- 设置对特定用户进行监听、收集历史sql语句
-- 关闭所有前台线程(所有会话)进行监听、收集历史sql语句
UPDATE performance_schema.setup_actors
SET ENABLED = 'NO', HISTORY = 'NO'
WHERE HOST = '%'
AND USER = '%';

-- 开启对特定用户进行监听、收集历史sql语句
INSERT INTO performance_schema.setup_actors
(HOST, USER, ROLE, ENABLED, HISTORY)
VALUES('%','root','%','YES','YES');


-- 确保statement、stage仪表开启
-- 
-- performance_schema.setup_instruments表中的name like '%statement/%'的记录的ENABLED字段为'YES', TIMED字段为'YES'
SELECT * FROM performance_schema.setup_instruments
WHERE NAME LIKE '%statement/%';

UPDATE performance_schema.setup_instruments
SET ENABLED = 'YES', TIMED = 'YES'
WHERE NAME LIKE '%statement/%';


-- performance_schema.setup_instruments表中的name like'%stage/%'的记录的ENABLED字段为'YES', TIMED字段为'YES'
SELECT * FROM performance_schema.setup_instruments
WHERE NAME LIKE '%stage/%';


UPDATE performance_schema.setup_instruments
SET ENABLED = 'YES', TIMED = 'YES'
WHERE NAME LIKE '%stage/%';


-- 



