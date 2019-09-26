-- 常见函数


/*
函数概念：类似于java中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名

## 分类
* 单行函数
    如 concat(str1, str2, ...), length(str), ifnull(expr1, expr2)
* 分组函数
    功能：用于统计，也称统计函数、聚合函数、组函数


*/

-- 字符函数
--

-- lenght(str) 获取字符串长度
SELECT LENGTH('trip');
SELECT LENGTH('神功盖世') -- 长度为：12，在utf8中一个汉字占3个字节

SHOW VARIABLES LIKE '%char%'; -- 查看服务端使用的字符集

-- CONCAT(str1,str2,...)拼接字符串
SELECT CONCAT(first_name, ' ', last_name) AS 姓名
FROM employees

-- UPPER(str)字符串转大
SELECT UPPER('abcdef');

-- LOWER(str)字符串转小写
SELECT LOWER('Guang Dong')

# 示例：将姓变大写，名变小写，然后拼接
SELECT CONCAT(UPPER(first_name), ' ',LOWER(last_name)) 姓名
FROM employees

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
SUBSTRING(str FROM pos 对应SUBSTR(str FROM pos FOR len)


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
    CONCAT (
        UPPER (SUBSTR (fname, 1, 1)), LOWER (SUBSTR (fname, 2))
    ) AS 姓名
FROM
    (SELECT
        CONCAT (first_name, ' ', last_name) AS fname
    FROM
        employees) employees;
        





