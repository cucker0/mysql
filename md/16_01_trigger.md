# trigger(触发器)

## 触发器是什么
触发器是一种特殊的存储过程。

触发器是与表关联的命名数据库对象，当该表发生特定事件时会激活它。触发器的一些用途是对要插入表中的值执行检查，或对更新中涉及的值执行计算。

MySQL触发器仅在SQL语句对表进行更改时激活。

INFORMATION_SCHEMA 或 performance_SCHEMA 表中的更改不会激活触发器。这些表实际上是视图，不允许在视图上使用触发器


### 触发器的用途
* 在MySQL中，只有执行 insert, delete, update 操作时才能触发触发器的执行。
* 触发器的这种特性可以协助应用在数据库端确保数据的完整性，日志记录，数据校验等操作。
* 使用别名OLD和NEW来引用触发器中发生变化的记录内容，这与其他的数据库是相似的。现在触发器还只支持行级触发，不支持语句级触发。


### 触发器与存储过程的异同
* 相同点
    
    触发器是一种特殊的存储过程，触发器和存储过程一样是一个能够完成特定功能、存储在数据库服务器上的SQL片段

* 不同点

    存储过程调用时需要手动调用 SQL 片段，而触发器不需要调用，当对数据库表中的数据执行 DML 操作时自动触发这个 SQL 片段的执行，无需手动调用。
    
## 触发器的创建语法
参考 https://docs.oracle.com/cd/E17952_01/mysql-8.0-en/create-trigger.html  
https://docs.oracle.com/cd/E17952_01/mysql-8.0-en/information-schema-triggers-table.html

```sql
CREATE
    [DEFINER = user]
    TRIGGER [IF NOT EXISTS] trigger_name
    trigger_time trigger_event
    ON tbl_name FOR EACH ROW
    [trigger_order]
    trigger_body

trigger_time: { BEFORE | AFTER }

trigger_event: { INSERT | UPDATE | DELETE }

trigger_order: { FOLLOWS | PRECEDES } other_trigger_name

trigger_body: 需要执行的语句。当有多个 SQL 语句要执行的，则使用 begin ... end 包裹
```
触发器只能与一个持久化表关联

不能将触发器与 TEMPORARY 表 或 视图相关联

* 示例
    ```mysql
    CREATE DATABASE IF NOT EXISTS mydb01_trigger;

    USE mydb01_trigger;

    -- 用户表
    CREATE TABLE IF NOT EXISTS USER(
     uid INT PRIMARY KEY AUTO_INCREMENT,
     username VARCHAR(50) NOT NULL,
     PASSWORD VARCHAR(50) NOT NULL
    )DEFAULT CHARSET=utf8;

    -- 用户信息操作日志表
    CREATE TABLE IF NOT EXISTS user_logs(
     id INT PRIMARY KEY AUTO_INCREMENT,
     TIME TIMESTAMP,
     log_text VARCHAR(255)
     )DEFAULT CHARSET=utf8;
     
    -- 需求1:当user表添加一行数据，则会自动在user_log添加日志记录
    -- 定义触发器： trigger_test1
    CREATE TRIGGER trigger_test1 AFTER INSERT ON USER FOR EACH ROW
    INSERT INTO user_logs VALUES(NULL,NOW(),'new');

    -- 在user表添加数据，让触发器自动执行
    INSERT INTO USER VALUES(3,'zbb','123456');
     
     
    -- NEW 和 OLD
    -- insert 触发器
    -- NEW
    -- 定义触发器： trigger_test2
    DROP TRIGGER trigger_test1
    CREATE TRIGGER trigger_test2 AFTER INSERT ON USER FOR EACH ROW
    INSERT INTO user_logs VALUES(NULL,NOW(),CONCAT('有新用户添加,信息为：',NEW.username,NEW.password));

    INSERT INTO USER VALUES(4,'abb','123456');

    -- update 触发器
    -- NEW
    -- 定义触发器： trigger_test3
    -- OLD
    DROP TRIGGER trigger_test2
    CREATE TRIGGER trigger_test3 AFTER UPDATE ON USER FOR EACH ROW
    INSERT INTO user_logs VALUES(NULL,NOW(),CONCAT('有用户信息修改,旧数据是：',OLD.uid,OLD.username,OLD.password));

    UPDATE USER SET PASSWORD = '00000' WHERE uid=3;

    -- NEW
    DROP TRIGGER trigger_test3
    CREATE TRIGGER trigger_test4 AFTER UPDATE ON USER FOR EACH ROW
    INSERT INTO user_logs VALUES(NULL,NOW(),CONCAT('有用户信息修改：新数据是',NEW.uid,NEW.username,NEW.password));

    UPDATE USER SET PASSWORD = '666666' WHERE uid=3;

    -- delete类型触发器
    -- OLD
    CREATE TRIGGER trigger_test5 AFTER DELETE ON USER FOR EACH ROW
    INSERT INTO user_logs VALUES(NULL,NOW(),CONCAT('有用户被删除，删除信息为：',OLD.uid,OLD.username,OLD.password));

    DELETE FROM USER WHERE uid=3;
    ```

## 查看触发器
```mysql
SELECT * FROM INFORMATION_SCHEMA.TRIGGERS
    WHERE TRIGGER_SCHEMA='schema_name' AND TRIGGER_NAME='trigger_name'\G
```
schema_name  // 数据库名


## 删除触发器
```mysql
DROP TRIGGER [IF EXISTS] [schema_name.]trigger_name
```
schema_name  // 数据库名


