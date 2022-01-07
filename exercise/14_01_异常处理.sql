# 条件处理(异常处理)

CREATE DATABASE testdb14 CHARSET utf8mb4;

USE testdb14;

-- 准备数据
CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    age TINYINT DEFAULT 0,
    email VARCHAR(32) UNIQUE
);

SHOW CREATE TABLE employee;
/*
Table     Create Table
--------  ------------------------------------------------------------------
employee  CREATE TABLE `employee` (                                         
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `name` varchar(32) NOT NULL,                                    
            `age` tinyint(4) DEFAULT '0',                                   
            `email` varchar(32) DEFAULT NULL,                               
            PRIMARY KEY (`id`),                                             
            UNIQUE KEY `email` (`email`)                                    
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
*/

-- 出错的示例

-- 插入数据
INSERT INTO employee (age, email) VALUES (20, 'libin@qq.com');
/*
错误代码： 1364
Field 'name' doesn't have a default value
*/

INSERT INTO employee (`name`, age, email) VALUES ('Mark', 18, 'mark@gmail.com');
INSERT INTO employee (`name`, age, email) VALUES ('Mark', 18, 'mark@gmail.com');

-- 存储过程
DROP PROCEDURE IF EXISTS insert_data;  -- 删除存储过程insert_data

-- 
DELIMITER $$

CREATE PROCEDURE insert_data ()
BEGIN
    SET @opt_state = -1;
    INSERT INTO employee (`name`, age, email) VALUES (NULL, 20, 'libin@qq.com');
    SET @opt_state = 1;
    INSERT INTO employee (`name`, age, email) VALUES ('Lilith', 21, 'lilith@gmail.com');
    SET @opt_state = 2;
END $$

DELIMITER ;


-- 调用存储过程
CALL insert_data();

SELECT @opt_state;  -- 结果为：-1
SELECT * FROM employee; -- 结果一条记录也没有插入成功

## 定义错误条件
-- 错误提示：ERROR 1048 (23000): Column 'name' cannot be null

-- 匹配mysql error code的方式
DECLARE field_cannot_be_null CONDITION FOR 1048;
-- 匹配 sqlstate的方式
DECLARE field_cannot_be_null CONDITION FOR SQLSTATE '23000';


## 异常处理器
/*
condition_value: {
    mysql_error_code
  | SQLSTATE [VALUE] sqlstate_value
  | condition_name
  | SQLWARNING
  | NOT FOUND
  | SQLEXCEPTION
}
*/

-- mysql_error_code
DECLARE CONTINUE HANDLER FOR 1051 SET @info='no_such_table';

-- SQLSTATE sqlstate_value
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info='no_such_table';

-- condition_name
-- 先定义condition变量，再引用
DECLARE no_this_table CONDITION FOR 1051;
DECLARE EXIT HANDLER FOR no_this_table SET @info='no_such_table';

-- SQLWARNING
DECLARE EXIT HANDLER FOR SQLWARNING SET @info='error';

-- NOT FOUND
DECLARE EXIT HANDLER FOR NOT FOUND SET @info='not_found';

-- SQLEXCEPTION
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION @info='has_exception';

-- 同时捕获多个异常类型
DECLARE CONTINUE HANDLER 
FOR 1051, SQLSTATE '42S02' 
BEGIN 
    SET @info='error';
    -- ...
END;


-- 异常处理完整示例
DELIMITER $$

CREATE PROCEDURE insert_data_v2 (OUT opt_code TINYINT)
/*
插入记录出错后，继续往下执行程序

IN
OUT
    opt_code: 操作的状态码
*/
BEGIN
    DECLARE state TINYINT DEFAULT 0;
    
    -- 定义异常处理器
    -- ERROR 1048 (23000): Column 'name' cannot be null 
    -- 使用下列方式中其中的一种就可以 
    -- 方式1
    DECLARE CONTINUE HANDLER FOR 1048 SET state = -1;
    /*
    -- 方式2
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET state = -1;
    
    -- 方式3（先声明condition，再引用）
    DECLARE cannot_be_null CONDITION FOR 1048;
    DECLARE CONTINUE HANDLER FOR cannot_be_null SET state = -1;    
    */
    
    INSERT INTO employee (`name`, age, email) VALUES (NULL, 20, 'libin@qq.com');
    SET state = 1;
    INSERT INTO employee (`name`, age, email) VALUES ('Lilith', 21, 'lilith@gmail.com');
    SET state = 2;
    
    SET opt_code = state;
END $$

DELIMITER ;


-- 调用上面的存储过程
CALL insert_data_v2(@code);

SELECT @code;  -- 2，说明执行到了存储过程中最后的SQL




