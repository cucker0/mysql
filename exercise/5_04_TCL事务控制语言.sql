-- TCL事务控制语言


/*
事务含义: ，一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部都不执行

* mysql中只有innodb引擎支持事务

## 事务特点(ACID)
* Atomicity原子性
    事务是一个不可再分割的工作单元，事务中的操作要么都执行，要么都不执行。
    就像原子核一样不能再侵害了。
* Consistency一致性
    事务必须使数据库从一个一致性状态变换到另外一个一致性状态
* Isolation隔离性
    事务的隔离性是指一个事务的执行不能被其他事务干扰。
    并发执行的各个事务之间不能互相干扰
* Durability持久性
    持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，持久化到文件系统了

## 事务的创建
事务能写的语句是表数据的insert、update、delete语句，也可以写select查询语句。

## 隐式事务
事务没有明显的开始和结束的标记，是自动的
指表数据的insert、update、delete语句


## 显式事务
事务有显式指明开始和结束标记，
前提：必须先设置 自动提交功能为禁用
set autocommit = 0;

## 显式事务语法
--要求：确保当前连接session的autocommit=0
set autocommit=0; --禁用自动提交事务功能，只对当前连接session起作用，执行一次即可


-- 开始事务
[start transaction;]

-- 事务的具体操作
编写事务中的sql语句(insert、update、delete、select)
语句1;
语句2;
...

-- 结束事务(以下二选一)
commit; -- 提交事务，确定上面的操作
rollback; -- 回滚事务，回滚上面的操作


## savepoint设置保存点，与rollback搭配使用
savepoint 保存点名;
ROLLBACK TO 保存点名; -- 回滚到指定的保存点，保存点之前的操作提交了，之后的回滚了

## 事务隔离级别
隔离级别            避免了脏读       避免了不可重复读(表数据update时)          避免了幻读(表数据插入时)       备注
read uncommitted    否               否                                        否
read commited       是               否                                        否                              oracle的默认事务隔离级别
repeatable read     是               是                                        否                              mysql默认事务隔离级别
serializable        是               是                                        是

不可重复读：不是每次读到的结果都一样
幻读：不是每次查询结果集行数都一样

效率有上往下递减

## 查看事务隔离级别
* mysql 8
select @@transaction_isolation

* mysql 8之前版本
select @@tx_isolation;

## 设置事务隔离级别
* mysql 8
set session|global transaction_isolation isolation 隔离级别;

* mysql 8之前版本
set session|global transaction isolation 隔离级别;


## 查看引擎
show engines;

## 关闭当前会话的自动提交事务功能，默认是开启的。关闭只是针对当前这个连接session的
SET autocommit = 0;
*/

SHOW VARIABLES LIKE 'autocommit';
SHOW ENGINES;

USE test;
CREATE TABLE account (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32) UNIQUE,
    balance DOUBLE
);

INSERT INTO account VALUES
(NULL, '张无忌', 2000),
(NULL, '赵敏', 2000);

SELECT * FROM account;

# 开启事务并提交
SET autocommit = 0;
SHOW VARIABLES LIKE 'autocommit';

START TRANSACTION;

UPDATE account SET balance = 1500 WHERE `name` = '张无忌';
UPDATE account SET balance = 2500 WHERE NAME = '赵敏';

COMMIT;

# 开启事务，并回滚
START TRANSACTION; -- 事务开始

UPDATE account SET balance = 3000 WHERE `name` = '张无忌';
UPDATE account SET balance = 1000 WHERE NAME = '赵敏';
SELECT * FROM account; -- 当前会话查看生效了

ROLLBACK; -- 事务结束

SELECT * FROM account;


# delete删除表所有记录、truncate清空表所有记录的事务回滚区别
START TRANSACTION;
DELETE FROM account;
ROLLBACK;
-- 查看结果，记录还在
SELECT * FROM account;


-- vs
START TRANSACTION;
TRUNCATE TABLE account;
ROLLBACK;
-- 查看结果，表记录被删除了，说明truncat清空表操作不可回滚
SELECT * FROM account;

# savepoint设置保存点
INSERT INTO account VALUES
(NULL, '张无忌', 2000),
(NULL, '赵敏', 2000);
SELECT * FROM account;


SET autocommit = 0; -- 若本session的autocommit已经关闭，则可不执行此语句
START TRANSACTION;
DELETE FROM account
WHERE `name` = '赵敏';
SAVEPOINT sp1; -- 设置保存点，保存点名为sp1
DELETE FROM account
WHERE `name` = '张无忌';

ROLLBACK TO sp1; -- 回滚到指定的sp1保存点，保存点之前的操作提交了，之后的回滚了

SELECT * FROM account; -- 张无忌没有删除

SELECT @@tx_isolation;

