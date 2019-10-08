-- 常见的数据类型



/*
* 数值型
    * 整型
    * 小数
        * 浮点型
        * 定点型
* 字符型
    *较短的文本
        >char、varchar
    * 较长的文本
        >text
    * 较短的二进制
        >binary、varbinary
    * 较长的二进制
        blob
    * enum
        >枚举类型，指定项里的单选
    * set
        >集合类型，指定项里的多选
*/

-- 整型
--
/*
## 分类
整数类型            占用空间  有符号范围           无符号范围       默认的长度
* tinyint       1字节     -2^7 ~ (2^7 - 1)     2^0 ~ 2^8 - 1
* smallint      2字节     -2^15 ~ (2^15 - 1)   0 ~ 2^16 - 1
* mediumint     3字节     -2^23 ~ (2^23 - 1)   0 ~ 2^24 - 1
* int/integer   4字节     -2^31 ~ (2^31 - 1)   0 ~ 2^32 - 1
* bigint        8字节     -2^63 ~ (2^63 - 1)   0 ~ 2^64 - 1


## 特点
* 不显示指定为无符号时，默认是有符号的
* 字段 数值类型 unsigned：表示该字段设置无符号数值
* 字段 整型 (长度) zerofill： 长度表示查询时显示的最大宽度，不影响存储，如果位数<指定的长度则会用0在左边填充，同时该字段已经设置为无符号整型
    如果不加zerefill是不生效的，只指定长度没有意义。
    字段的值范围与这里指定的长度无关，只与所使用的整数类型的范围有关    
* 如果不设置长度，会有默认的长度，即为最大值的位数，长度表示显示的宽度

* 

*/

# 设置有符号整型字段
CREATE TABLE tab_int (
    price INT,
    num INT
);

DESC tab_int;
INSERT INTO tab_int VALUES(1122, 1122);
INSERT INTO tab_int VALUES(-1122, -1122);
INSERT INTO tab_int VALUES(2147483648,2147483648); -- 报错：Out of range value for column 'price' at row 1

SELECT * FROM tab_int;

# 设置无符号整型字段
CREATE TABLE tab_int2 (
    price INT (7) UNSIGNED,
    num INT (8) ZEROFILL
);

DESC tab_int2;

INSERT INTO tab_int2 VALUES (-1, 0); -- 报错：Out of range value for column 'price' at row 1


-- 小数
-- 
/*
## 小数分类
* 浮点型
    * float (M, D)
    * double (M, D)
* 定点型
    * decimal (M, D)  -- decimal也可以简写成dec


## 特点
* M: 整个数的位数，整数位数 + 小数倍数的和
* D: 小数位数
* M和D都可以省略，
    * 如果是decimal，轩M默认为10，D默认为0，即相当于 decimal (10, 0)
    * 如果是float和double，则不指定M、D的值，保留插入数据的精度，插入多少位小数的是多少就保存多少位小数
* 小数位数小于D的，用0在右边补够D位小数
* 定点型的精确度较高，如果要求插入数值的精度要求较高的，如货币运算则可以考虑使用decimal定点型
* float、double小数位数超过M后，M+1 位上的数<= 5舍去，>5收上来
* decimal小数位数超过M后，采用四舍五入，M+1 位上的数< 5舍去，>=5收上来

## 原则
选择类型越简单越好，能满足保存数值的类型越小越好

*/

# 

DROP TABLE tab_float;

CREATE TABLE tab_float (
    f1 FLOAT,
    f2 DOUBLE,
    f3 DECIMAL
);

DESC tab_float;
INSERT INTO tab_float VALUES (235.12, 235.12, 235.1); -- 235.1 处报生产警告，插入的值被改为235
INSERT INTO tab_float VALUES (2.71828, 3.1415926, 100);

SELECT * FROM tab_float;



CREATE TABLE tab_float2 (
    f1 FLOAT (6, 2),
    f2 DOUBLE (8, 2),
    f3 DECIMAL (10, 4)
);

DESC tab_float2;
INSERT INTO tab_float2 VALUES (11.12, 11.12, 11.1234);
INSERT INTO tab_float2 VALUES (12.1, 12.1, 12.1);
INSERT INTO tab_float2 VALUES (13.123, 13.123, 13.12345); -- 产生一个警告，
INSERT INTO tab_float2 VALUES (14.125, 14.125, 14.12344); -- 插入到数据库的值分别为：14.12, 14.12, 14.1234
INSERT INTO tab_float2 VALUES (15.126, 15.126, 15.12345); -- 插入到数据库的值分别为：14.13, 14.13, 14.1235
INSERT INTO tab_float2 VALUES (12345.125, 1234567.125, 1234567.12345); -- 报错:Out of range value for column

SELECT * FROM tab_float2;


-- 字符型
-- 
/*

## 分类
*较短的文本
    >char、varchar
* 较长的文本
    >text
* 较短的二进制
    >binary、varbinary
* 较长的二进制
    blob
* enum
    >枚举类型，指定项里的单选
* set
    >集合类型，指定项里的多选，忽略大小写。
    多个选项之间使用英文逗号分隔，选项之间不能有空格，多个选项拼接成一个字符串，

## 特点
类型    写法            M的含义        特点                  空间的耗费       效率
char    char (M)        最大的字符数   可以省略，默认为1，   比较耗费         高
                                       固定长度的字符
varchar varchar (M)     最大的字符数   不可省略，            比较节省         相对低些，当数据量很多时，硬盘IO成为瓶颈，这时varchar效率可能更高
                                       可变长度字符

*/


CREATE TABLE tab_str (
    `name` CHAR (32),
    address VARCHAR (64)
);

DESC tab_str;
INSERT INTO tab_str VALUES ('王大仙', '滚石路人民大街A城');

SELECT * FROM tab_str;

--
CREATE TABLE tab_str2 (
    `name` CHAR, -- 默认为1
    address VARCHAR (64)
);

INSERT INTO tab_str2 VALUES ('王大仙', '滚石路人民大街A城'); -- 报错：Data too long for column 'name' at row 1


CREATE TABLE tab_enum (
    answer ENUM ('a', 'b', 'c', 'd')

);

DESC tab_enum;

INSERT INTO tab_enum VALUES ('a');
INSERT INTO tab_enum VALUES ('b');
INSERT INTO tab_enum VALUES ('e'); 报错：1265  DATA truncated FOR COLUMN 'answer' AT ROW 1
INSERT INTO tab_enum VALUES ('A');

SELECT * FROM tab_enum;

--
CREATE TABLE tab_set (
    answer SET ('a', 'b', 'c', 'd')
);

DESC tab_set;

INSERT INTO tab_set VALUES ('a');
INSERT INTO tab_set VALUES ('a,b');
INSERT INTO tab_set VALUES ('a,b,c,d');
INSERT INTO tab_set VALUES ('a,g'); -- 包含set选项外的将报错：Data truncated for column 'answer' at row 1

SELECT * FROM tab_set;




