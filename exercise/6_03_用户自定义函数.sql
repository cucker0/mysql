-- 用户自定义函数


/*
## 函数创建语法
delimiter $

create function 函数名(参数名1 参数1的类型, ...) return 返回类型
begin
    函数体(一组的sql语句);
end$

delimiter ;


* 一个参数分成两部分
参数名 参数类型

* 返回值
有且仅有一个返回值，所以必须有return语句;

* 省略begin、end关键字情况
当函数体中只有一个语句时，可以省略begin、end关键字

* 函数提结束符(提交分界符)
结束使用提交分界符结尾

* 函数体不能使用外部的用户变量

* 函数体不能定义用户变量，只能定义局部变量
*/

-- 用户自定义函数调用语法
/*
select 函数名(实参列表);

与系统函数调用方法相同
*/


# 无参函数
# 案例：返回公司员工个数，减去一个老板

USE myemployees;


DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
    DECLARE c INT DEFAULT 0;
    SELECT COUNT(*) INTO c FROM employees; -- COUNT(*)最终的值赋值给局部变量c。这里的查询结果不会显示
    RETURN c - 1; -- 返回结果
END$

DELIMITER ;

/*
提示错误:
ERROR 1418 (HY000): This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA 
in its declaration and binary logging is enabled 
(you *might* want to use the less safe log_bin_trust_function_creators variable)


原因：开启了bin-log功能，但未开启函数功能
解决方法1：通过修改全局变量来开启函数功能。重启mysql服务后失效
set global log_bin_trust_function_creators=1;

解决方式2: 编缉my.cnf,添加如下内容，永久生效

[mysqld]

log-bin-trust-function-creators = 1

重启mysql服务
*/


SELECT myf1();

# 有参函数
# 案例：创建函数实现：输入last_name，返回他对应的工资
DELIMITER $

CREATE FUNCTION myf2(lname VARCHAR(32)) RETURNS DOUBLE (10, 2)
BEGIN
    SET @gongzi = 0;
    SELECT salary INTO @gongzi
    FROM employees
    WHERE last_name = lname;
    RETURN @gongzi;
END$

DELIMITER ;

SELECT myf2('Kochhar');


# 案例：创建函数：输入部门名，返回该部门的平均工资
DELIMITER $
CREATE FUNCTION myf3(dname VARCHAR(20)) RETURNS DOUBLE
BEGIN
    DECLARE avg_salary DOUBLE DEFAULT 0;
    SELECT AVG(e.salary) INTO avg_salary
    FROM employees e
    RIGHT OUTER JOIN departments d
    ON e.department_id = d.department_id
    WHERE d.department_name = dname;
    RETURN avg_salary;
END$
DELIMITER ;

SELECT myf3('IT');


# 案例：创建函数：传入两个float数，返回这两数之和


DELIMITER $
DROP FUNCTION IF EXISTS mysum$
CREATE FUNCTION mysum(n1 FLOAT, n2 FLOAT) RETURNS DOUBLE
BEGIN
    RETURN n1 + n2;
END$
DELIMITER ;

SELECT mysum(1.1, 2.2);

-- 查看用户自定义函数
-- mysql 8，列出指定库的所有用户自定义函数
SELECT * FROM information_schema.routines
WHERE routine_schema = '库名' AND routine_type = 'FUNCTION';

-- mysql 8之前版，列出指定库的所有用户自定义函
SELECT * FROM mysql.`proc` WHERE `type` = 'FUNCTION';


SHOW CREATE FUNCTION myf1; -- 查看指定用户自定义函数的创建结构


-- 删除自定义用户函数
-- 只能一次删除一个
DROP FUNCTION 用户自定义函数名;


DROP FUNCTION myf1;


-- 修改用户自定义函数(不能更改函数体和参数列表，只能更改函数特性)
/*
## 语法
ALTER FUNCTION func_name [characteristic ...]

characteristic包括:
    COMMENT 'string'
  | LANGUAGE SQL
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
  | SQL SECURITY { DEFINER | INVOKER }


此语句可用于更改存储函数的特性。在alter function语句中可以指定多个更改。
但是不能使用此语句更改存储函数的参数或主体；
若要进行此类更改，必须使用drop function和create function删除并重新创建该函数

-- https://dev.mysql.com/doc/refman/5.5/en/alter-function.html
*/

SELECT SPECIFIC_NAME,SQL_DATA_ACCESS,ROUTINE_COMMENT 
FROM information_schema.Routines
WHERE ROUTINE_NAME='mysum';


ALTER FUNCTION mysum
READS SQL DATA
COMMENT 'find float number sum.';


SELECT SPECIFIC_NAME,SQL_DATA_ACCESS,ROUTINE_COMMENT 
FROM information_schema.Routines
WHERE ROUTINE_NAME='mysum';
