-- 常见函数


/*
函数概念：类似于java中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名

## 分类
* 单行函数
    如 concat(str1, str2, ...), length(str), ifnull(expr1, expr2)
* 分组函数
    功能：用于统计，也称统计函数、聚合函数、组函数

## 单行函数
### 字符函数
    lenght(str) 获取字符串字节长度(在utf8字符集中一个汉字占3个字节, gbk为2字节)
    CONCAT(str1,str2,...) 拼接字符串
    UPPER(str)字符串转大写
    LOWER(str)字符串转小写
    SUBSTR(str,pos)、SUBSTRING(str,pos)
    SUBSTR(str,pos,len)、SUBSTRING(str,pos, len) 截取子字符串
    INSTR(str,substr) 返回子串第一次出现的首地址索引，如果找不到返回0
    TRIM(str) 去掉字符串str首尾的空格
    TRIM(remstr FROM str) 从字符串str中去掉首尾指定的字符remstr
    LPAD(str,len,padstr) 用指定的字符padstr左填充str，保证填充后的字符串长度为len，并返回充后的字符串
    RPAD(str,len,padstr) 用指定的字符padstr右填充str，保证填充后的字符串长度为len，并返回充后的字符串
    REPLACE(str,from_str,to_str) 把字符串str中所有的from_str字符替换成字符to_str

### 数学函数
    ROUND(X) 数X的绝对值做四舍五入运算，精确到个位，符号不变
    ROUND(X,D) 小数X的绝对值做四舍五入运算，精确到第D位小数，符号不变
    CEIL(X) 向上取整，返回>= X的最小整数
    FLOOR(X) 向下取整，返回 <= X的最大整数
    TRUNCATE(X,D) 截断数X小数点后第D位之后所有小数，直接截断(填补0)，不做四舍五入
    MOD(N,M) 取模运算，求余数，数N模以数M
    
### 日期、时间函数
    NOW()返回服务器当前 日期时间，属于date,也属于time
    CURDATE() 返回服务期系统当前日期，不包括时间
    CURTIME() 返回服务期系统当前时间，不包括日期
    从指定的日期或时间对象中获取年、月、日、时、分、秒，月份名称
    YEAR(date) 从日期date中获取年
    MONTH(date) 从日期date中获取月
    DAY(date) 从日期date中获取日
    HOUR(time) 从时间time中获取时
    MINUTE(time) 从时间time中获取分
    SECOND(time) 从时间time中获取秒
    MONTHNAME(date) 从日期date中获取月份名称
    STR_TO_DATE(str,format) 根据日期格式format将字符创str转成日期，并返回
    DATE_FORMAT(date,format) 格式化date对象，根据日期格式format将日期date转换成字符串，并返回
    DATEDIFF(expr1,expr2) 计算expr1, expr2的天数差值,日期时间expr1 - 日期时间expr2的天数
    
### 其他函数
    SELECT VERSION(); 查看服务端mysql版本
    SELECT DATABASE(); 查看当前连接的库
    SELECT USER(); 查看当前使用的连接用户

### 控制函数
    IF(expr1,expr2,expr3) 如果逻辑表达式expr1为true,则返回表达式expr2，否则返回表达式expr3
    case用于字段或表达式值枚举处理
    case用于字段或表达式值范围枚举处理
*/

-- 字符函数
--

-- lenght(str) 获取字符串字节长度(在utf8中一个汉字占3个字节, gbk为2字节)
SELECT LENGTH('trip');
SELECT LENGTH('神功盖世'); -- 长度为：12

SHOW VARIABLES LIKE '%char%'; -- 查看服务端使用的字符集

-- CONCAT(str1,str2,...)拼接字符串
SELECT CONCAT(first_name, ' ', last_name) AS 姓名
FROM employees;

-- UPPER(str)字符串转大写
SELECT UPPER('abcdef');

-- LOWER(str)字符串转小写
SELECT LOWER('Guang Dong');

# 示例：将姓变大写，名变小写，然后拼接
SELECT CONCAT(UPPER(first_name), ' ',LOWER(last_name)) 姓名
FROM employees;

-- 截取子字符串(SUBSTR、SUBSTRING)
/*
字符串的索引从1开始计数


SUBSTR(str,pos) 截取指定str字符串从第pos个字符开始到结尾的子字符串
SUBSTR(str,pos,len) 截取str字符串从第pos个字符开始，长度为len的子字符串的子字符串
SUBSTR(str FROM pos) 与SUBSTR(str,pos)功能相同，截取str字符串从第pos个字符开始到结尾的子字符串
SUBSTR(str FROM pos FOR len) 与SUBSTR(str,pos,len)功能相同，截取str字符串从第pos个字符开始，长度为len的子字符串

SUBSTRING(str,pos) 对应SUBSTR(str,pos)
SUBSTRING(str,pos,len) 对应SUBSTR(str,pos,len)
SUBSTRING(str FROM pos) 对应SUBSTR(str FROM pos)
SUBSTRING(str FROM pos FOR len) 对应SUBSTR(str FROM pos FOR len)


*/
# 截取从指定索引处后面所有字符
SELECT SUBSTR('习近平致信祝贺大庆油田发现60周年全文', 4) out_put; -- 致信祝贺大庆油田发现60周年全文

# 截取从指定索引处指定字符长度的字符
SELECT SUBSTR('习近平致信祝贺大庆油田发现60周年全文', 4, 2) out_put; -- 致信
SELECT SUBSTR('abcdef' FROM 2); -- bcdef
SELECT SUBSTR('abcdef' FROM 2 FOR 3); -- bcd

SELECT SUBSTRING('习近平致信祝贺大庆油田发现60周年全文', 4);


# 案例：姓名中首字符大写，其他字符小写然后用_拼接，显示出来
SELECT
    CONCAT (
        UPPER(SUBSTR(first_name, 1, 1)),
        LOWER(SUBSTR(first_name, 2)),
        ' ',
        LOWER(last_name)
    )
FROM
    employees;

--
SELECT
    CONCAT (UPPER(SUBSTR(fname, 1, 1)), LOWER(SUBSTR(fname, 2))) AS 姓名
FROM
    (SELECT CONCAT (first_name, ' ', last_name) AS fname FROM employees) employees;


-- INSTR(str,substr) 返回子串第一次出现的首地址索引，如果找不到返回0
/*
SQL中，0表示false, 1表示true

*/
SELECT INSTR('上海自来水来自海上,山西运煤车煤运西山,自来水', '自来水'); -- 结果：3


-- TRIM(str) 去掉字符串str首尾的空格
-- TRIM(remstr FROM str) 从字符串str中去掉首尾指定的字符remstr
SELECT LENGTH(TRIM('    Good    ')); -- 4
SELECT TRIM('e' FROM 'eeeeeeee张eee教主eeeeeeeeeeeeeeeeeee'); -- 张eee教主


-- LPAD(str,len,padstr) 用指定的字符padstr左填充str，保证填充后的字符串长度为len，并返回充后的字符串
/*
当len小于str的长度时，会截断右边多余的字符 (保留左边的)
*/
SELECT LPAD('2', 3,'0'); -- '002'

SELECT LPAD('中国海军', 2,'c'); -- '中国'


-- RPAD(str,len,padstr) 用指定的字符padstr右填充str，保证填充后的字符串长度为len，并返回充后的字符串
/*
当len小于str的长度时，会截断右边多余的字符 (保留左边的)
*/

SELECT RPAD('中国海军', 12,'c'); -- 中国海军cccccccc
SELECT RPAD('中国海军', 2,'c'); -- '中国'

-- REPLACE(str,from_str,to_str) 把字符串str中所有的from_str字符替换成字符to_str
SELECT REPLACE('周芷若周芷若周芷若周芷若张无忌爱上了周芷若', '周芷若', '赵敏');


-- 数学函数
--

-- ROUND数值做四舍五入运算
/*
ROUND(X) 数X的绝对值做四舍五入运算，精确到个位，符号不变
ROUND(X,D) 小数X的绝对值做四舍五入运算，精确到第D位小数，符号不变
*/
SELECT ROUND(1.55); -- 2
SELECT ROUND(-1.55); -- 结果：-2
SELECT ROUND(-3.1415, 3); -- 3.142

-- CEIL(X) 向上取整，返回>= X的最小整数
SELECT CEIL(2.11); -- 3
SELECT CEIL(-2.11); -- -2

-- FLOOR(X) 向下取整，返回 <= X的最大整数
SELECT FLOOR(3.11); -- 3
SELECT FLOOR(-3.11); -- -4

-- TRUNCATE(X,D) 截断数X小数点后第D位之后所有小数，直接截断(填补0)，不做四舍五入
/*
D必须是整数，
D为0：表示小数点后所以小数截断不要
D为负数，表示小数点左边D位内的都取0
*/
SELECT TRUNCATE(3.333333, 1); -- 3.3
SELECT TRUNCATE(3.333333, 0); -- 3
SELECT TRUNCATE(33, 1); -- 33
SELECT TRUNCATE(3333, -2); -- 3300

-- MOD(N,M) 取模运算，求余数，数N模以数M
/*
MOD(N,M) ==> N - N/M * M
*/
SELECT MOD(10, 3); -- 1
SELECT MOD(10, -3); -- 1
SELECT MOD(-10, -3); -- -1
SELECT MOD(-10, 3); -- -1
SELECT 10 % 3;


-- 日期函数
--

-- NOW()返回服务器当前 日期时间，属于date,也属于time
SELECT NOW(); -- 2019-09-27 10:31:58

-- CURDATE() 返回服务期系统当前日期，不包括时间
SELECT CURDATE(); -- 2019-09-27

-- CURTIME() 返回服务期系统当前时间，不包括日期
SELECT CURTIME(); -- 10:34:07

-- 从指定的日期或时间对象中获取年、月、日、时、分、秒，月份名称
/*
now() 获取的日期时间对象，属于date和time类型

YEAR(date) 从日期date中获取年
MONTH(date) 从日期date中获取月
DAY(date) 从日期date中获取日
HOUR(time) 从时间time中获取时
MINUTE(time) 从时间time中获取分
SECOND(time) 从时间time中获取秒
MONTHNAME(date) 从日期date中获取月份名称
DATEDIFF(expr1,expr2) 日期时间expr1 - 日期时间expr2的天数
*/

SET @now=NOW(); -- 设置局部变量，引用变量 @变量名
SELECT @now;

SELECT YEAR(@now);
SELECT YEAR(NOW());
SELECT YEAR('2008-01-10'); -- 2008
SELECT YEAR('2008/01/10'); -- 2008
SELECT YEAR('2008.1.10'); -- 2008
SELECT YEAR(hiredate) AS 年 FROM employees;

--
SELECT MONTH(NOW()); 
SELECT MONTH('2019-06-01');

--
SELECT MONTHNAME(@now); -- September

-- 
SELECT DAY(NOW());

--
SELECT HOUR(NOW());
SELECT HOUR(CURTIME());

--
SELECT MINUTE(NOW());

--
SELECT SECOND(NOW());
SELECT SECOND('12:00:13');


-- STR_TO_DATE(str,format) 根据日期格式format将字符创str转成日期，并返回
SELECT STR_TO_DATE('1999-12-31', '%Y-%c-%d');

# 示例：查询入职日期为1992-4-3的员工信息
SELECT * 
FROM employees
WHERE hiredate = '1992-4-3';
--
SELECT * FROM employees
WHERE hiredate = STR_TO_DATE('4-3 1992', '%c-%d %Y');

-- DATE_FORMAT(date,format) 格式化date对象，根据日期格式format将日期date转换成字符串，并返回
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日'); -- 2019年09月27日

# 查询有奖金的员工名和入职日期(xx月/xx日 xx年)
SELECT first_name, DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS 入职日期
FROM employees
WHERE commission_pct IS NOT NULL;



-- 其他函数
--

/*
SELECT VERSION(); 查看服务端mysql版本
SELECT DATABASE(); 查看当前连接的库
SELECT USER(); 查看当前使用的连接用户
*/
SELECT VERSION();
SELECT DATABASE();
SELECT USER(); -- root@localhost


-- 流程分支控制函数
--

-- IF(expr1,expr2,expr3) 如果逻辑表达式expr1为true,则返回表达式expr2，否则返回表达式expr3
/*
功能类似三目运算：expr1 ? expr2 : expr3

expr2,expr3的类型要求相同或能兼容
*/

SELECT IF(2 < 4, '小', '大'); -- 小

SELECT 
    first_name,
    commission_pct,
    IF(commission_pct IS NULL, '无', '有') AS 是否有奖金
FROM employees;

-- IFNULL(expr1,expr2) 如果表达式expr1为null，则返回expr2, 否则返回expr1
SELECT IFNULL(commission_pct, '无奖金')
FROM employees;

-- case用于字段或表达式值枚举处理
 /*
功能类似java中的case
switch(变量或表达式或枚举类) {
    case 常量1:
        语句1;
        break;
    case 常量2:
        语句2;
        break;
    ...
    default:
        语句n;
        break;
}


mysql中的case:
case 字段或表达式
when 常量1 then
    返回的值1或语句1
when 常量2 then
    返回的值2或语句2
...
[else 返回的值n或语句n]
end

*/
/*案例：查询员工的工资，要求

部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍
其他部门，显示的工资为原工资

*/
SELECT
    department_id,
    salary 原工资,
    CASE department_id
WHEN 30 THEN
    salary * 1.1
WHEN 40 THEN
    salary * 1.2
WHEN 50 THEN
    salary * 1.3
ELSE salary
END AS 新工资
FROM employees;

-- case用于字段或表达式值范围枚举处理
/*
功能类似java中的多重if：

if(逻辑表达式1) {
    语句1;
} else if(逻辑表达式2) {
    语句2;
} 
...
else {
    语句n;
}


mysql中:
case
when 逻辑表达式1 then 返回的值1或语句1
when 逻辑表达式2 then 返回的值2或语句2
...
[else 默认返回的值n或语句n]
end

*/

/*
# 案例：查询员工的工资的情况
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资>10000，显示C级别
否则，显示D级别
*/

SELECT 
    salary,
    CASE
WHEN salary > 20000 THEN
    'A'
WHEN salary > 15000 THEN
    'B'
WHEN salary > 10000 THEN
    'C'
ELSE 'D'
END AS 级别
FROM employees;


