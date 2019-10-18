-- 存储过程和用户定义函数


/*
Stored Procedure
function

概念：事先经过编译并保存在数据库中的一组sql语句集合。类似java中的方法


## 存储过程和自定义函数的优点
* 提高代码的重用性
* 简化操作
* 减少了编译次数，并且减少了客户端与服务器的连接次数，
减少数据在数据库和应用服务器之间的传输，提高了效率



## 存储过程、函数对比
* 本质上没区别
* 语法
    
    
* 返回值
    * 函数有且仅有一个返回值，指定返回值的数值类型
    * 存储过程可以没有返回值、可以返回一个或多个值

* 限制不同
    函数中函数体的限制较多，不能使用显式或隐式方式打开
    transaction、commit、rollback、set autocommit=0等, 
    存储过程可以使用几乎所有的sql语句，use不能用
* 赋值方式
    * 函数可以采用select ... into ...方式和set值得方式进行赋值， 只能用return返回结果集
    * 存储过程可以使用select的方式进行返回结果集
* 调用方式
    * select 函数名(参数列表);
    * call 存储过程名(参数列表);
* 
    * 存储过程实现的功能要复杂一点，功能强大些，可以执行包括修改表等一系列数据库操作
    * 函数的实现的功能针对性比较强，用户定义函数不能用于执行一组修改全局数据库状态的操作

*/



-- 存储过程
-- 

-- 创建存储过程语法
/*
create procedure 存储过程名(参数模式 参数名 参数类型, ...)
begin
    存储过程体(一组合法的sql语句);
end 提交分隔符

* 参数模式
in: 标识该参数为传入参数，省略参数模式，默认为in
out: 标识该参数为返回的参数
inout: 标识该参数即使传入的参数，又是返回的参数

* 使用mysql自带的客户端，需要重置提交分隔符，
    默认为;
    提交分隔符可以是一个字符也可以是多个字符
    delimiter 提交分隔符
    为什么要修改提交符，是因为存储体中已经有了默认的;提交符，
    但创建存储过程这个方法时，还不能提交，必须到end 结束处才能提交，说到底还是mysql客户端做得不够智能
* Navicat Premium等客户端
    Navicat Premium、SQLyog有独立的窗口编辑窗口可以编写存储过程和函数
* 如果存储过程体只有一个语句，可以省略begin、end关键字
* 存过过程体中的sql语句必须以;结尾

*/


-- 调用存储过程语法
/*
call 存储过程名(实参列表);

需要有supper权限
*/

# 空参列表
# 案例：使用存储过程插入5条数据到girls库的admin表中


USE girls;
SELECT * FROM admin;

DELIMITER $
-- 表示提交分隔符设置为$, 注意后面没有;，可以设置多个字符组合为提交分隔符
-- 此修改只作用于当前连接会话
-- delimiter ;;  -- 表示提交分隔符为 ;;


DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
    INSERT INTO admin (username, `password`) VALUES
    ('tom1', '123456'),
    ('tom2', '123456'),
    ('tom3', '123456'),
    ('tom4', '123456'),
    ('tom5', '123456');
END$

DELIMITER ;
CALL myp1();

TRUNCATE TABLE admin;


# 创建带in模式参数的存储过程
# 案例：创建存储过程实现输入女神名，返回对应的男神信息

DELIMITER $

CREATE PROCEDURE myp2(IN girlName VARCHAR(50))
BEGIN
    SELECT bo.*
    FROM boys bo
    RIGHT JOIN beauty b
    ON bo.id = b.boyfriend_id
    WHERE b.name = girlName;
END$

DELIMITER ;

CALL myp2('苍老师');


# 用存储过程实现：输入用户名、密码，判断用户是否登录成功

DELIMITER $
DROP PROCEDURE IF EXISTS myp3;
CREATE PROCEDURE myp3(IN username VARCHAR(20), IN pwd VARCHAR(10))
BEGIN
    DECLARE result INT DEFAULT 0; -- 声明一个局部变量(局部变量只能贴着begin)，用来表示登录是否成功，= 0：不成功，!= 0：成功
    
    -- USE girls; -- 存储过程中不允许使用use
    DROP TABLE IF EXISTS admin;
    
    CREATE TABLE `admin` (    
        `id` INT(11) PRIMARY KEY AUTO_INCREMENT,  
        `username` VARCHAR(10) NOT NULL,    
        `password` VARCHAR(10) NOT NULL
    );                                                                                                                                                                 CALL myp1();                         
                                                                                                                                                          
    SELECT COUNT(*) INTO result
    FROM admin
    WHERE admin.`username` = username AND admin.`password` = pwd;
    
    SELECT IF(result = 0, '失败', '成功');
END$
DELIMITER ;


CALL myp3('tom1', '123456');

SELECT * FROM admin;
SHOW CREATE TABLE admin;


DROP PROCEDURE myp4;


# 创建out模式参数的存储过程
# 案例：用存储过程实现，输入女神名，返回对应男神名

DELIMITER $
DROP PROCEDURE myp5$
CREATE PROCEDURE myp5(IN bname VARCHAR(10), OUT boyname VARCHAR(10) )
BEGIN 
    SELECT bo.boyName INTO boyname -- 赋值给返回的参数，由系统自动返回out模式的参数，不用写return，也无法写
    FROM beauty b
    LEFT OUTER JOIN boys bo
    ON b.boyfriend_id = bo.id
    WHERE b.name = bname;

END$

DELIMITER ;

SET @ret = '';  -- 定义用户变量
CALL myp5('周芷若', @ret);
SELECT @ret;

CALL myp5('小昭', @ret2);
SELECT @ret2;


SELECT * FROM beauty;


# 多个out模式参数
# 案例2：存储 过程：根据输入的女神名，返回对应的男神名和魅力值
DELIMITER $
CREATE PROCEDURE myp6(IN bname VARCHAR(20), OUT boyname VARCHAR(20), OUT num INT)
BEGIN
    SELECT bo.boyName, bo.userCP INTO boyname, num
    FROM boys bo
    RIGHT OUTER JOIN beauty b
    ON bo.id = b.boyfriend_id
    WHERE b.name = bname;

END$

DELIMITER ;

CALL myp6('王语嫣', @boname, @cp);
SELECT @boname, @cp;


# 创建带inout模式参数的存储过程
# 案例：输入a、bg两个参数，a、b翻倍并返回
DELIMITER $
CREATE PROCEDURE myp7(INOUT a INT, INOUT b INT)
BEGIN
    SET a = a * 2;
    -- set b = b * 2;
    SELECT b * 2 INTO b;
END$

DELIMITER ;

SET @m = 10;
SET @n = 20;
CALL myp7(@m, @n);
SELECT @m, @n;


# 查看存储过程
SHOW CREATE PROCEDURE 存储过程名;

SHOW CREATE PROCEDURE myp7;

-- mysql 8，查看所有存储过程
SELECT * FROM information_schema.routines
WHERE routine_schema = '库名' AND routine_type = 'PROCEDURE';

-- mysql 8之前版本，查看所有存储过程
SELECT * FROM mysql.`proc` WHERE `type` = 'PROCEDURE';

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `myp7`(INOUT a INT, INOUT b INT) 
BEGIN                                                                        
    SET a = a * 2;                                                           
                                                                                                                                                     
    SELECT b * 2 INTO b;                                                     
END
*/

# 删除存储过程
DROP PROCEDURE 存储过程名; -- 只能一次删除一个
DROP PROCEDURE myp5;


USE mysql;
SHOW TABLES;


SELECT * FROM information_schema.routines WHERE routine_schema = 'girls' AND routine_type = 'PROCEDURE';


-- 

DELIMITER $
DROP PROCEDURE IF EXISTS myp8;
CREATE PROCEDURE myp8()
BEGIN
    DECLARE aa INT;
    DECLARE bb FLOAT;
    DECLARE cc DOUBLE;
    DECLARE dd CHAR;
    DECLARE ee VARCHAR(10);
    SELECT aa, bb, cc, dd, ee;
END$
DELIMITER ;

CALL myp8();



