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

-- 数值做四舍五入运算
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

-- TRUNCATE(X,D) 截断数X小数点后第D位之后所有小数，直接截断，不做四舍五入
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










