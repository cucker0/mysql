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
end;


* 情况2: 值范围枚举
case
when 条件1 then
    语句1;
when 条件2 then
    语句2;
...
else
    语句n;
end;

* 位置：在任何位置


*/




