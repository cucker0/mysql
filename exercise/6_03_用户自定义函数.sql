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
# 案例：返回公司员工个数

USE myemployees;


DELIMITER $
CREATE FUNCTION myf1(aa INT) RETURNS INT
BEGIN
    DECLARE c INT DEFAULT 0;
    SELECT COUNT(*) INTO c FROM employees; -- COUNT(*)最终的值赋值给局部变量c
    RETURN c;
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

log_bin_trust_routine_creators = 1

重启mysql服务
*/


SELECT myf1();





