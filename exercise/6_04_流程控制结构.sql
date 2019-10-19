-- 流程控制结构


/*
## 流程控制结构分类
* 顺序结构
    从上往下依次执行
* 分支结构
    * if分支
    * case分支
* 循环结构
    * while循环
    * loop循环
    * repeat循环
*/


-- 分支结构
-- 

-- if函数
/*
## 语法
if(表达式1, 表达式2, 表达式3)
功能：如果表达式1为真，则返回表达式2，否则返回表达式3
即三目运算
在任何地方使用

*/

# 示例：返回两数中较小的数
SELECT IF(10 < 3, 10, 3);


-- if分支
/*
## 语法
if 表达式1 then
    语句1;
elseif 表达式2 then
    语句2;
...
else
    语句n;
end if;

功能：类似java的多重if分支判断

* 位置：只能在begin ... end中
*/


# 案例：创建函数实现：
/*
传入成绩，
如果成绩>90,返回A;
如果成绩>80,返回B;
如果成绩>60,返回D;
否则,返回D;

*/

DELIMITER $
CREATE FUNCTION fun1(score INT) RETURNS CHAR(1)
BEGIN
    SET @lev = 'D';
    IF score > 90 AND score <= 100 THEN
        SET @lev = 'A';
    ELSEIF score > 80 THEN
        SET @lev = 'B';
    ELSEIF score > 60 THEN
        SET @lev = 'C';
    ELSE
        SET @lev = 'D';
    END IF;
    
    RETURN @lev;
END$

DELIMITER ;

SELECT fun1(88);

# 案例2：创建存储过程，实现下列功能：
/*
输入员工的工资
如果工资<2000,则删除，
如果5000>工资>=2000,则涨工资1000，
否则涨工资500

*/

DELIMITER $
CREATE PROCEDURE myp1(IN gz DOUBLE)
BEGIN
    IF gz < 2000 THEN
        DELETE FROM employees
        WHERE salary = gz;
    ELSEIF gz < 5000 AND gz >= 2000 THEN
        UPDATE employees SET salary = salary + 1000
        WHERE salary = gz;
    ELSE
        UPDATE employees SET salary = salary + 500
        WHERE salary = gz;
    END IF;
END$

DELIMITER ;

CALL myp1(9000);


-- case结构
/*
## 语法
* 情况1: 值枚举
case 变量或表达式
when 值1 then
    语句1;
when 值2 then
    语句2;
...
else
    语句n;
end case;


* 情况2: 值范围枚举
case
when 条件1 then
    语句1;
when 条件2 then
    语句2;
...
else
    语句n;
end case;

* 位置：begin ... and 中



case做分支函数语法
[case做分支函数语法](#流程分支控制函数)

*/


# 案例：创建函数case实现：
/*
传入成绩，
如果成绩>90,返回A;
如果成绩>80,返回B;
如果成绩>60,返回D;
否则,返回D;

*/

DELIMITER $
CREATE FUNCTION func2(score INT) RETURNS CHAR(1)
BEGIN
    DECLARE ret CHAR DEFAULT 'D';
    CASE
    WHEN score BETWEEN 90 AND 100 THEN
        SET ret = 'A';
    WHEN score > 80 THEN
        SET ret = 'B';
    WHEN score > 60 THEN
        SET ret = 'C';
    ELSE
        SET ret = 'D';
    END CASE;
    RETURN ret;
END$
DELIMITER ;

SELECT func2(66);

SELECT * FROM information_schema.routines
WHERE routine_schema = 'myemployees' AND routine_type = 'FUNCTION';


--  循环结构
/*
## 分类
* while
* loop
* repeat

## 循环控制
* leave
    类似java中的break，跳出当前循环，即结束当前循环，也可以结合标签跳出哪个循环
* iterate
    类似java中的continue，结束本次循环(本次循环执行到continue这就结束)，继续下一次循环

当要进行循环控制时，要指定循环标签
*/


-- while
/*
## while语法
初始化条件;
[label标签:]
while 循环条件 do
    循环体;
    迭代条件;
end while [label标签]; -- 此处的label标签任何时候都可以省略

可以嵌套

--
相当于java中的while
初始化条件;
while (循环条件) {
    循环体;
    迭代条件;
}
*/

-- loop无限循环
/*
## 语法
[label标签名:]
loop
    循环体;
end loop [label标签名]; -- 此处的label标签任何时候都可以省略


相当于 while (true) {
    循环体;
}

*/


-- repeat
/*
## 语法
[label标签名:]
repeat
    循环体;
untile 结束循环条件 -- 注意这里没有;
end repeat [label标签名]; -- 此处的label标签任何时候都可以省略

相当于
初始化条件;
do {
    循环体;
    迭代条件;
}
while (循环条件);
*/

# 案例：批量插入，根据指定的次数插入到admin表中多条记录
USE girls;

DELIMITER $
DROP PROCEDURE IF EXISTS while1;
CREATE PROCEDURE while1(IN num INT) 
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= num DO
        INSERT INTO admin (username, `password`) VALUES
        (CONCAT('tom', i), '123456');
        SET i = i + 1;
    END WHILE;

END$

DELIMITER ;

CALL while1(3);


# leave控制提前循环退出
#案例：批量插入，根据次数插入到admin表中多条记录，如果次数>10则停止
DELIMITER $
DROP PROCEDURE IF EXISTS while2;
CREATE PROCEDURE while2(IN num INT)
BEGIN 
    SET @i = 1;
    label1:
    WHILE @i <= num DO
        INSERT INTO admin (username, `password`) VALUES
        (CONCAT('dafenqi', @i), '888888');
        IF @i >= 10 THEN
            LEAVE label1;
        END IF;
        SET @i = @i + 1;
        
        SET @j = 0;
        WHILE @j < 3 DO
            SELECT @j;
            SET @j = @j + 1;
        END WHILE;
    END WHILE;
END$

DELIMITER ;


TRUNCATE TABLE admin;
SELECT * FROM admin;

CALL while2(30);

# iterate结束本次循环
#案例：批量插入，根据次数插入到admin表中多条记录，只插入偶数次
DELIMITER $
CREATE PROCEDURE while3(IN num INT)
BEGIN
    SET @i = 0;
    lab1:
    WHILE @i <= num DO
        SET @i = @i + 1;
        IF @i % 2 != 0 THEN
           ITERATE lab1; -- 结束本次循环
        END IF;
        INSERT INTO admin (username, `password`) VALUES
        (CONCAT('zhenbiao', @i), '666666');
    END WHILE;

END$

DELIMITER ;


TRUNCATE TABLE admin;
SELECT * FROM admin;

CALL while3(10);


-- loop循环测试
DROP PROCEDURE IF EXISTS loop1;

DELIMITER $
CREATE PROCEDURE loop1()
BEGIN
    SET @i = 0;
    lab1:
    LOOP
        SET @i = @i + 1;
        IF @i > 10 THEN
            LEAVE lab1;
        END IF;   
        SELECT @i;
    END LOOP;
END$

DELIMITER ;

CALL loop1();


-- repeat循环测试
# 创建存储过程实现：输入打印次数，不管次数是否>0，至少打印一次，打印内容为"(x次) 打怪10个"
DELIMITER $
CREATE PROCEDURE repeat1(IN num INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    lab1:
    REPEAT 
        SET i = i + 1;
        SELECT CONCAT('(', i, '次) 打怪10个') AS '结果';
        IF num < 0 THEN -- 要满足：num >= 0
            LEAVE lab1;
        END IF;
    UNTIL i >= num -- 这里没有;
    END REPEAT;
END$

DELIMITER ;


CALL repeat1(0);
CALL repeat1(-10);
CALL repeat1(4);



